import json
from bd import obtener_conexion
from funciones_auxiliares import sanitize_field

# =========================
# CATÁLOGO (rutinas base)
# =========================
def obtener_rutinas_filtradas(objetivo, nivel, dias):
    conexion = obtener_conexion()
    try:
        with conexion.cursor() as cursor:
            cursor.execute(
                """
                SELECT id, nombre, rutina_json
                FROM rutinas_base
                WHERE objetivo = %s AND nivel = %s AND dias = %s
                """,
                (objetivo, nivel, dias)
            )
            rutinas = cursor.fetchall()
            for r in rutinas:
                r["nombre"] = sanitize_field(r["nombre"])
                r["rutina_json"] = json.loads(r["rutina_json"])

            return rutinas

    finally:
        conexion.close()


# =========================
# RUTINAS DEL USUARIO
# =========================
def guardar_rutina_usuario(usuario_id, rutina_base_id):
    conexion = obtener_conexion()
    try:
        with conexion.cursor() as cursor:
            cursor.execute(
                """
                INSERT INTO rutinas_usuario (usuario_id, rutina_base_id)
                VALUES (%s, %s)
                """,
                (usuario_id, rutina_base_id)
            )
            conexion.commit()
    finally:
        conexion.close()


def obtener_rutinas_usuario(usuario_id):
    conexion = obtener_conexion()
    try:
        with conexion.cursor() as cursor:
            cursor.execute("""
                SELECT ru.id AS rutina_usuario_id,
                       rb.nombre,
                       rb.rutina_json,
                       ru.created_at
                FROM rutinas_usuario ru
                JOIN rutinas_base rb ON rb.id = ru.rutina_base_id
                WHERE ru.usuario_id = %s
                ORDER BY ru.created_at DESC
            """, (usuario_id,))

            rutinas = cursor.fetchall()

            for r in rutinas:
                r["nombre"] = sanitize_field(r["nombre"])
                r["rutina_json"] = json.loads(r["rutina_json"])

            return rutinas
    finally:
        conexion.close()
