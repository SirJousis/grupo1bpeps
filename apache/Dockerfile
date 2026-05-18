FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        apache2 \
        libapache2-mod-security2 \
        modsecurity-crs \
        curl && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod security2 proxy proxy_http headers

RUN cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf && \
    sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf && \
    sed -i 's|SecAuditLog /var/log/modsec_audit.log|SecAuditLog /var/log/modsecurity/audit.log|' \
        /etc/modsecurity/modsecurity.conf

RUN mkdir -p /var/log/modsecurity

RUN sed -i \
    -e 's/ServerTokens OS/ServerTokens Prod/' \
    -e 's/ServerSignature On/ServerSignature Off/' \
    /etc/apache2/conf-available/security.conf

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/error.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/other_vhosts_access.log

COPY demo.apache.conf /etc/apache2/sites-available/000-default.conf
COPY ./html /var/www/html/
RUN chmod 644 /var/www/html/*.html

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]