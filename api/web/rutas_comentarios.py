from __future__ import print_function
from flask import request, Blueprint, jsonify, make_response
import controlador_comentarios
from funciones_auxiliares import sanitize_field, prepare_response_extra_headers

bp = Blueprint('comentarios', __name__)

@bp.route("/", methods=['POST'])
def login():
    if not request.is_json:
        response = make_response(jsonify({"status": "Bad request"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    comentario_json = request.get_json()
    usuario = sanitize_field(comentario_json.get('usuario', ''))
    descripcion = sanitize_field(comentario_json.get('descripcion', ''))

    if not usuario or not descripcion:
        response = make_response(jsonify({"status": "Bad request"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    if not isinstance(usuario, str) or not isinstance(descripcion, str):
        response = make_response(jsonify({"status": "Bad parameters"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response
    if len(usuario) > 50 or len(descripcion) > 500:
        response = make_response(jsonify({"status": "Bad parameters"}), 400)
        response.headers.extend(prepare_response_extra_headers(True))
        return response

    respuesta, code = controlador_comentarios.insertar_comentario(usuario, descripcion)

    response = make_response(jsonify(respuesta), code)
    response.headers.extend(prepare_response_extra_headers(True))
    return response

@bp.route("/",methods=['GET'])

def consultaComentarios():
    respuesta,code= controlador_comentarios.obtener_comentarios()
    response = make_response(jsonify(respuesta), code)
    response.headers.extend(prepare_response_extra_headers(True))
    return response
