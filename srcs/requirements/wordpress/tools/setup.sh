#!/bin/bash

echo "📄 DB: $MYSQL_DATABASE"
echo "👤 USER: $MYSQL_USER"
echo "🔑 PASSWORD: $MYSQL_PASSWORD"
echo "🌍 HOST: mariadb"
echo "🌐 DOMAIN: $DOMAIN_NAME"

sleep 3

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
fi



# Lance PHP-FPM en foreground
exec /usr/sbin/php-fpm7.4 -F