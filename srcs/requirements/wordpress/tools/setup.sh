#!/bin/bash

# BONUS config msmtprc pour le service mail de wordpress
cat > /etc/msmtprc << EOF
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account        gmail
host           ${SMTP_HOST}
port           ${SMTP_PORT}
from           ${SMTP_FROM}
user           ${SMTP_USER}
password       ${SMTP_PASS}

account default : gmail
EOF

chmod 600 /etc/msmtprc
chown www-data:www-data /etc/msmtprc

ln -sf /usr/bin/msmtp /usr/sbin/sendmail

sleep 5

# Télécharge WordPress si absent
if [ ! -f /var/www/html/index.php ]; then
    curl -o /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 && \
    chown -R www-data:www-data /var/www/html && \
    rm /tmp/latest.tar.gz
fi

# Crée un wp-config propre si absent
if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --path=/var/www/html \
        --allow-root

    #bonus redis config
    wp config set WP_REDIS_HOST "redis" --type=constant --allow-root --path=/var/www/html
    wp config set WP_REDIS_PORT 6379 --type=constant --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_TIMEOUT 1 --type=constant --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_READ_TIMEOUT 1 --type=constant --raw --allow-root --path=/var/www/html
    wp config set WP_REDIS_SCHEME "tcp" --type=constant --allow-root --path=/var/www/html

fi

# Installation WordPress automatique si non encore faite
if ! wp core is-installed --path=/var/www/html --allow-root; then
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path=/var/www/html \
        --allow-root
    wp theme install bizboost  --allow-root --path="/var/www/html"
    wp theme activate bizboost  --allow-root --path="/var/www/html"

    wp plugin install redis-cache --activate --allow-root --path=/var/www/html #bonus
    wp redis enable --allow-root --path=/var/www/html #bonus redis
    wp redis status --allow-root --path=/var/www/html | grep "Status:" #bonus redis
fi

# Lance PHP-FPM en foreground
echo "Subject: Wordpress Launched" | msmtp --debug --from=default -t "${SMTP_FROM}"
exec /usr/sbin/php-fpm7.4 -F