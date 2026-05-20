from flask import Blueprint, request, jsonify, session, make_response
import controlador_usuarios
import re
from app import limiter
from pymysql.err import IntegrityError
from otpgen import verificar_otp
from funciones_auxiliares import sanitize_field, prepare_response_extra_headers

bp = Blueprint('auth', __name__, url_prefix='/api/auth')

# ========== REGISTRO ==========
@bp.route('/registro', methods=['POST'])
def registro():
    if not request.is_json:
        response = make_response(jsonify({"error": "Bad request"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    datos = request.get_json()
    username = sanitize_field(datos.get('username'))
    password = datos.get('password')

    # Validar campos obligatorios
    if not username or not password:
        response = make_response(jsonify({"error": "Faltan datos"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    # Validar username
    if len(username) < 4 or len(username) > 12:
        response = make_response(jsonify({"error": "Longitud de username inválida"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    if not re.match(r'^[a-zA-Z0-9_]+$', username):
        response = make_response(jsonify({"error": "Carácteres no válidos en el username"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    # Validar contraseña
    if not re.match(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!_@.]).{8,}$', password):
        response = make_response(jsonify({"error": "Contraseña no cumple los requisitos de seguridad"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    try:
        resultado = controlador_usuarios.registrar_usuario(username, password)
        session["pending_otp_setup_id"] = resultado["id"]
        response = jsonify({
            "mensaje": "Usuario registrado. Escanea el QR con tu autenticador.",
            "qr": resultado["qr"]
        })
        response.headers.extend(prepare_response_extra_headers(True))
        return response, 201
    except IntegrityError:
        response = make_response(jsonify({"error": "El usuario ya existe"}), 409)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    except Exception as e:
        print("Error inesperado en registro:", e)
        response = make_response(jsonify({"error": "Error interno al registrar usuario"}), 500)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
# ========== LOGIN ==========
@bp.route("/login", methods=["POST"])
@limiter.limit("5 per minute")
def login():
    if not request.is_json:
        response = make_response(jsonify({"error": "Bad request"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    login_json = request.get_json()
    username = sanitize_field(login_json.get("username"))
    password = login_json.get("password")

    if not username or not password:
        response = make_response(jsonify({"error": "Faltan datos"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    if not isinstance(username, str) or not isinstance(password, str) or len(username) > 50 or len(password) > 50:
        response = make_response(jsonify({"error": "Parámetros inválidos"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    usuario = controlador_usuarios.validar_login(username, password)
    if not usuario or not isinstance(usuario, dict):
        response = make_response(jsonify({"error": "Credenciales inválidas"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    session["pending_otp_user_id"] = usuario["id"]
    session["pending_otp_username"] = usuario["username"]
    session["pending_otp_secret"] = usuario["otp_secret"]
    response = make_response(jsonify({"status": "otp_required"}), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response

# ========== VERIFY OTP ==========
@bp.route("/verify-otp", methods=["POST"])
def verify_otp():
    if not request.is_json:
        response = make_response(jsonify({"error": "Bad request"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    user_id = session.get("pending_otp_user_id")
    username = session.get("pending_otp_username")
    otp_secret = session.get("pending_otp_secret")

    if not user_id or not otp_secret:
        response = make_response(jsonify({"error": "No hay autenticación OTP pendiente"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    data = request.get_json()
    token = sanitize_field(data.get("token", ""))

    if not re.match(r'^\d{6}$', token):
        response = make_response(jsonify({"error": "Token inválido"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    if not verificar_otp(otp_secret, token):
        response = make_response(jsonify({"error": "Código OTP incorrecto"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    session.pop("pending_otp_user_id", None)
    session.pop("pending_otp_username", None)
    session.pop("pending_otp_secret", None)
    session.permanent = True
    session["id_usuario"] = user_id
    session["username"] = username
    response = make_response(jsonify({"status": "ok"}), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response

# ========== LOGOUT ==========
@bp.route("/logout", methods=['POST'])
def logout():
    user_id = session.get('id_usuario')
    if not user_id:
        response = make_response(jsonify({"status": "No hay sesión activa"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    resultado = controlador_usuarios.cerrar_sesion(user_id)
    session.clear()

    if resultado:
        response = make_response(jsonify({"status": "Sesión cerrada correctamente"}), 200)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    else:
        response = make_response(jsonify({"status": "Error al cerrar sesión"}), 500)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

# ========== CHECK SESSION ==========
@bp.route('/check', methods=['GET'])
def check():
    if 'id_usuario' in session:
        response = make_response(jsonify({"status": "ok"}), 200)
    else:
        response = make_response(jsonify({"status": "unauthorized"}), 401)
    response.headers.extend(prepare_response_extra_headers(True))
    return response
