from flask import Flask
from flask_cors import CORS
from datetime import timedelta
import os
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(get_remote_address, default_limits=[])


def create_app():
    app = Flask(__name__)

    allowed_origin = os.getenv("ALLOWED_ORIGIN", "http://localhost")
    CORS(app, supports_credentials=True, origins=[allowed_origin])

    limiter.init_app(app)

    app.config['SECRET_KEY'] = os.getenv("gym_app_secret_key")
    app.config['SESSION_COOKIE_HTTPONLY'] = False
    app.config['SESSION_COOKIE_SECURE'] = True  
    app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'
    app.permanent_session_lifetime = timedelta(hours=1)

    UPLOAD_FOLDER = "/app/uploads"
    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

    from rutas_auth import bp as auth_bp
    from rutas_rutinas import bp as rutinas_bp
    from rutas_ficheros import bp as ficheros_bp
    from controlador_comentarios import comentarios_bp
    from rutas_usuarios import bp as usuarios_bp

    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(rutinas_bp, url_prefix="/api/rutinas")
    app.register_blueprint(ficheros_bp, url_prefix="/api/ficheros")
    app.register_blueprint(comentarios_bp, url_prefix="/api/comentarios")
    app.register_blueprint(usuarios_bp, url_prefix="/api/usuarios")

    return app


if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=5000, debug=False)
