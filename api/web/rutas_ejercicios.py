from flask import Blueprint, make_response, jsonify
from funciones_auxiliares import prepare_response_extra_headers

# El nombre 'bp' es el que busca app.py
bp = Blueprint('ejercicios', __name__)

@bp.route('/ejercicios', methods=['GET'])
def listar_ejercicios():
    # Tu lógica aquí...
    response = make_response(jsonify({"ejercicios": ["ejercicio1", "ejercicio2"]}), 200)
    response.headers.extend(prepare_response_extra_headers(True))
    return response