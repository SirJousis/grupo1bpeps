# Gym Routine Generator – API REST en Python
## Descripción del proyecto

Este proyecto consiste en una aplicación web basada en una API REST desarrollada en Python que permite a los usuarios registrarse, autenticarse y generar rutinas de gimnasio personalizadas en función de los parámetros seleccionados (objetivo, nivel, días de entrenamiento, etc.).

La aplicación implementa persistencia de datos mediante MariaDB, permite la gestión completa (CRUD) de rutinas, incluye sistema de comentarios, subida y visualización de archivos, y un sistema de login y logout de usuarios.

El proyecto ha sido desarrollado siguiendo una arquitectura modular basada en Flask y Blueprints, reutilizando el código base proporcionado por el profesor.

## Cambios de seguridad
 [X] Sanitización de datos (Evitar inyecciones)
    - Se añade la función sanitize_field en todos los campos de salida y entrada
 [X] Añadido cabeceras de segurudad
   - X-Content-Type-Options: nosniff	Evita MIME-sniffing
   - X-Frame-Options: DENY	Bloquea clickjacking en iframes
   - X-XSS-Protection: 1; mode=block	Protección XSS en navegadores antiguos
   - Strict-Transport-Security	Fuerza HTTPS
   - Content-Security-Policy	Restringe carga de recursos
   - Referrer-Policy	Controla información enviada en cabecera Referer
   - Permissions-Policy	Deshabilita geolocalización, micrófono y cámara
   - Cache-Control: no-store	Evita cacheo de respuestas sensibles
[X] Especificar el uso de SALT en el hash de la contraseña con method='pbkdf2:sha256', salt_length=16
[X] Eliminado archivos calculariva.py y .bak de sql (el resto mantener por si nos da por terminarlo)

