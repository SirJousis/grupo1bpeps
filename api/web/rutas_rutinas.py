from flask import Blueprint, jsonify, request, session, make_response
import controlador_rutinas
from funciones_auxiliares import sanitize_field, prepare_response_extra_headers

bp = Blueprint('rutinas', __name__, url_prefix='/api/rutinas')


# =========================
# CATÁLOGO DE RUTINAS BASE
# =========================
@bp.route("/base", methods=["GET"])
def listar_rutinas_base():
    objetivo = sanitize_field(request.args.get("objetivo", ""))
    nivel = sanitize_field(request.args.get("nivel", ""))
    dias = request.args.get("dias", type=int)

    if not all([objetivo, nivel, dias]):
        return jsonify({"error": "Faltan filtros"}), 400

    rutinas = controlador_rutinas.obtener_rutinas_filtradas(
        objetivo, nivel, dias
    )
    response=make_response(jsonify(rutinas), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response


# =========================
# RUTINAS DEL USUARIO
# =========================
@bp.route("/usuario", methods=["GET"])
def listar_rutinas_usuario():
    usuario_id = session.get("id_usuario")
    if not usuario_id:
        response = make_response(jsonify({"error": "No autenticado"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    rutinas = controlador_rutinas.obtener_rutinas_usuario(usuario_id)
    response = make_response(jsonify(rutinas), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response


@bp.route("/usuario", methods=["POST"])
def guardar_rutina_usuario():
    usuario_id = session.get("id_usuario")
    if not usuario_id:
        response = make_response(jsonify({"error": "No autenticado"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    if not request.is_json:
        response = make_response(jsonify({"error": "Bad request"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    #Sanitizar y validar la entrada
    datos = sanitize_field(request.get_json())
    rutina_base_id = datos.get("rutina_base_id")
    if not rutina_base_id:
        response = make_response(jsonify({"error": "rutina_base_id obligatorio"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    if not isinstance(rutina_base_id, int):
        response = make_response(jsonify({"error": "rutina_base_id inválido"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    controlador_rutinas.guardar_rutina_usuario(
        usuario_id, rutina_base_id
    )

    response = make_response(jsonify({"mensaje": "Rutina guardada en tu perfil"}), 201)
    response.headers.extend(prepare_response_extra_headers(True))
    return response
