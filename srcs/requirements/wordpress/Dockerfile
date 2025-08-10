FROM debian:bullseye

# Installation de PHP-FPM + dépendances WordPress
RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip curl wget unzip \
    && mkdir -p /run/php

# Téléchargement de WordPress
RUN mkdir -p /var/www/html && \
    curl -o /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1 && \
    chown -R www-data:www-data /var/www/html && \
    rm /tmp/latest.tar.gz

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# BONUS relais SMTP
RUN apt-get update && apt-get install -y msmtp ca-certificates


# Copie de la config du pool PHP
COPY ./tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copie d’un script qui génère wp-config.php à partir des variables d’environnement
COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# Exposition du port FPM

# Lancement avec script d’installation (via ENTRYPOINT)
ENTRYPOINT [ "/setup.sh" ]
