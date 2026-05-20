FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        apache2 \
        libapache2-mod-security2 \
        libapache2-mod-evasive \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod security2 proxy proxy_http headers rewrite

# Global Apache config
COPY apache2.conf /etc/apache2/apache2.conf
COPY ports.conf /etc/apache2/ports.conf

# Virtual host
COPY demo.apache.conf /etc/apache2/sites-available/000-default.conf

# ModSecurity config + OWASP CRS 3.3.0
COPY modsecurity.conf /etc/modsecurity/modsecurity.conf
RUN mkdir -p /etc/apache2/modsecurity-crs /var/cache/modsecurity
COPY coreruleset-3.3.0/ /etc/apache2/modsecurity-crs/coreruleset-3.3.0/

# ModSecurity2 module config con CRS includes (reemplaza el de apt)
COPY security2.conf /etc/apache2/mods-available/security2.conf

# Cabeceras de seguridad
COPY security.conf /etc/apache2/conf-available/security.conf
RUN a2enconf security

# mod-evasive (protección DDoS)
COPY evasive.conf /etc/apache2/mods-enabled/evasive.conf
RUN mkdir -p /var/log/mod_evasive && chown www-data:www-data /var/log/mod_evasive

# Archivos estáticos
COPY ./html /var/www/html/
RUN chmod 644 /var/www/html/*.html

# Logs a stdout/stderr
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/error.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/other_vhosts_access.log

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
