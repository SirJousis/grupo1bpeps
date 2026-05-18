#FROM httpd:2.4-alpine
FROM httpd:2.4
# Actualizar paquetes
RUN apt-get update && apt-get upgrade -y

# Instalar ModSecurity y dependencias
RUN apt-get install -y \
    libapache2-mod-security2 \
    modsecurity-crs \
    curl

# Crear directorios necesarios
RUN mkdir -p /var/log/modsecurity

# Activar módulo ModSecurity
RUN echo "LoadModule security2_module /usr/lib/apache2/modules/mod_security2.so" \
>> /usr/local/apache2/conf/httpd.conf

# Configuración base ModSecurity
RUN echo "Include conf/extra/modsecurity.conf" \
    >> /usr/local/apache2/conf/httpd.conf

# Crear configuración ModSecurity
RUN mkdir -p /usr/local/apache2/conf/extra

RUN cat > /usr/local/apache2/conf/extra/modsecurity.conf <<'EOF'
<IfModule security2_module>

    SecRuleEngine On

    SecRequestBodyAccess On
    SecResponseBodyAccess Off

    SecAuditEngine RelevantOnly
    SecAuditLog /var/log/modsecurity/audit.log

    Include /etc/modsecurity-crs/crs-setup.conf
    Include /etc/modsecurity-crs/rules/*.conf

</IfModule>
EOF

# Copiar virtualhost
COPY demo.apache.conf /usr/local/apache2/conf/demo.apache.conf

# Copiar HTML
COPY ./html /var/www/html

# Permisos
RUN chmod 644 /var/www/html/*.html

# Incluir vhost
RUN echo "Include /usr/local/apache2/conf/demo.apache.conf" \
    >> /usr/local/apache2/conf/httpd.conf

EXPOSE 80
