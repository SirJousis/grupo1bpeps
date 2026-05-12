# controlador_ficheros.py
import os
import hashlib
from werkzeug.utils import secure_filename
from bd import obtener_conexion
from funciones_auxiliares import sanitize_field

ALLOWED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.pdf'}
MAX_SIZE_BYTES = 5 * 1024 * 1024

def guardar_archivo(file, upload_folder, user_id, rutina_usuario_id=None):
    try:
        if file.filename == "":
            return False, "Nombre de archivo vacío"

        nombre_original = secure_filename(file.filename)
        extension = os.path.splitext(nombre_original)[1].lower()

        if extension not in ALLOWED_EXTENSIONS:
            return False, "Tipo de archivo no permitido"

        contenido = file.read()
        
        if len(contenido) > MAX_SIZE_BYTES:
            return False, "Archivo demasiado grande (máximo 5 MB)"
        
        hash_md5 = hashlib.md5(contenido).hexdigest()
        
        file.seek(0)

        nombre_guardado = f"{hash_md5}{extension}"

        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)

        file.save(os.path.join(upload_folder, nombre_guardado))

        conn = obtener_conexion()
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO ficheros
            (usuario_id, nombre_original, nombre_guardado)
            VALUES (%s, %s, %s)
            """,
            (user_id, nombre_original, nombre_guardado)
        )
        conn.commit()
        conn.close()

        return True, {
            "nombre_original": sanitize_field(nombre_original),
            "nombre_guardado": sanitize_field(nombre_guardado)
        }

    except Exception as e:
        return False, str(e)



def obtener_ficheros_usuario(user_id):
    from bd import obtener_conexion
    conn = obtener_conexion()
    cursor = conn.cursor()
    cursor.execute(
        "SELECT nombre_original, nombre_guardado FROM ficheros WHERE usuario_id = %s",
        (user_id,)
    )
    data = cursor.fetchall()
    conn.close()
    return [sanitize_field(dict(f)) for f in data]

def obtener_ficheros_rutina(rutina_usuario_id, user_id):
    conn = obtener_conexion()
    cursor = conn.cursor()
    cursor.execute(
        """
        SELECT nombre_original, nombre_guardado
        FROM ficheros
        WHERE rutina_usuario_id = %s AND usuario_id = %s
        """,
        (rutina_usuario_id, user_id)
    )
    data = cursor.fetchall()
    conn.close()
    return [sanitize_field(dict(f)) for f in data]


def archivo_pertenece_usuario(nombre_archivo, user_id):
    conn = obtener_conexion()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT 1
            FROM ficheros
            WHERE nombre_guardado = %s
              AND usuario_id = %s
            """,
            (nombre_archivo, user_id)
        )
        return cursor.fetchone() is not None
    finally:
        conn.close()
