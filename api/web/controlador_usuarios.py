from werkzeug.security import generate_password_hash, check_password_hash
from bd import obtener_conexion
from datetime import datetime
from otpgen import gen_otp, verificar_otp
import pyotp

def validar_login(username, password):
    conn = obtener_conexion()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "SELECT id, username, password, failed_attempts, locked_until, otp_secret FROM usuarios WHERE username = %s", (username,)
            )
            usuario = cursor.fetchone()

            if not usuario:
                return None

            # Comprobar si locked_until = NONE y si tiene algún valor comprueba que el bloqueosiga activo
            if usuario["locked_until"] and usuario["locked_until"] > datetime.now():
                return "locked"

            # Contraseña incorrecta
            if not check_password_hash(usuario["password"], password):
                nuevos_intentos = usuario["failed_attempts"] + 1
                if nuevos_intentos >= 5:
                    # Bloquear 15 minutos
                    cursor.execute(
                        "UPDATE usuarios SET failed_attempts = %s, locked_until = DATE_ADD(NOW(), INTERVAL 15 MINUTE) WHERE id = %s",
                        (nuevos_intentos, usuario["id"])
                    )
                else:
                    cursor.execute(
                        "UPDATE usuarios SET failed_attempts = %s WHERE id = %s",
                        (nuevos_intentos, usuario["id"])
                    )
                conn.commit()
                return None

            # Login correcto: resetear contador
            cursor.execute(
                "UPDATE usuarios SET is_active = 1, failed_attempts = 0, locked_until = NULL WHERE id = %s",
                (usuario["id"],)
            )
            conn.commit()
            return {"id": usuario["id"], "username": usuario["username"], "otp_secret": usuario["otp_secret"]}

    except Exception:
        conn.rollback()
        return None
    finally:
        conn.close()

def registrar_usuario(username, password):
    conn = obtener_conexion()
    try:
        with conn.cursor() as cursor:
            key = pyotp.random_base32()
            cursor.execute(
                "INSERT INTO usuarios (username, password, is_active, otp_secret) VALUES (%s, %s, %s, %s)",
                (username, generate_password_hash(password, method='pbkdf2:sha256', salt_length=16), 1, key)
            )
            conn.commit()
            user_id = cursor.lastrowid
            qr_base64 = gen_otp(username, key)
            return {"id": user_id, "username": username, "qr": qr_base64}       
            
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        conn.close()

def cerrar_sesion(user_id):
    conn = obtener_conexion()
    try:
        with conn.cursor() as cursor:
            cursor.execute(
                "UPDATE usuarios SET is_active = 0 WHERE id = %s",
                (user_id,)
            )
            conn.commit() # ejecutar sentencias
            return True
    except Exception:
        conn.rollback()
        return False
    finally:
        conn.close() # cerrar conexion con la bbdd
