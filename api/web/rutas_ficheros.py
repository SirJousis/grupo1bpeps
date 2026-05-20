from flask import Blueprint, request, jsonify, session, current_app, send_from_directory, render_template, make_response
import re
import controlador_ficheros
from funciones_auxiliares import prepare_response_extra_headers

bp = Blueprint('ficheros', __name__, url_prefix='/api/ficheros')

# 1. SUBIR ARCHIVO
@bp.route('/subir', methods=['POST'])
def subir():
    if 'id_usuario' not in session:
        response = make_response(jsonify({"error": "No autorizado"}), 401)
        return response

    if 'archivo' not in request.files:
        response = make_response(jsonify({"error": "No se envió el archivo"}), 400)
        return response

    file = request.files['archivo']
    user_id = session['id_usuario']
    upload_folder = current_app.config['UPLOAD_FOLDER']

    exito, mensaje = controlador_ficheros.guardar_archivo(
    file,
    upload_folder,
    user_id
)


    if exito:
        return jsonify({"mensaje": mensaje}), 201
    else:
        return jsonify({"error": mensaje}), 500

# 2. LISTAR ARCHIVOS DEL USUARIO
@bp.route('/galeria', methods=['GET'])
def galeria():
    if 'id_usuario' not in session:
        return render_template("index.html")
    return render_template("archivos.html")


@bp.route('/listar', methods=['GET'])
def listar():
    if 'id_usuario' not in session:
        response = make_response(jsonify({"error": "No autorizado"}), 401)
        return response

    user_id = session['id_usuario']
    lista = controlador_ficheros.obtener_ficheros_usuario(user_id)
    response = make_response(jsonify(lista), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response

@bp.route('/ver/<nombre_archivo>')
def ver_archivo(nombre_archivo):
    if 'id_usuario' not in session:
        response = make_response(jsonify({"error": "No autorizado"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    if not re.match(r'^[a-zA-Z0-9._-]+$', nombre_archivo):
        response = make_response(jsonify({"error": "Nombre de archivo inválido"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    user_id = session['id_usuario']

    if not controlador_ficheros.archivo_pertenece_usuario(nombre_archivo, user_id):
        response = make_response(jsonify({"error": "Acceso denegado"}), 403)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    ## Mandar archivo al navegador
    return send_from_directory(
        current_app.config['UPLOAD_FOLDER'],
        nombre_archivo
    )


@bp.route('/subir/<int:rutina_usuario_id>', methods=['POST'])
def subir_foto_rutina(rutina_usuario_id):
    if 'id_usuario' not in session:
        return jsonify({"error": "No autorizado"}), 401

    if 'archivo' not in request.files:
        return jsonify({"error": "No se envió el archivo"}), 400

    user_id = session['id_usuario']
    file = request.files['archivo']
    upload_folder = current_app.config['UPLOAD_FOLDER']

    exito, mensaje = controlador_ficheros.guardar_archivo(
        file,
        upload_folder,
        user_id,
        rutina_usuario_id
    )

    if exito:
        return jsonify(mensaje), 201
    return jsonify({"error": mensaje}), 500


@bp.route('/rutina/<int:rutina_usuario_id>', methods=['GET'])
def listar_fotos_rutina(rutina_usuario_id):
    if 'id_usuario' not in session:
        response = make_response(jsonify({"error": "No autorizado"}), 401)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    user_id = session['id_usuario']
    fotos = controlador_ficheros.obtener_ficheros_rutina(rutina_usuario_id, user_id)
    response = make_response(jsonify(fotos), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response
