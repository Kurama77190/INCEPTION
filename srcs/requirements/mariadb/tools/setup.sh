#!/bin/bash

# create db
if [ ! -f "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo CREATING MARIADB
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    /etc/init.d/mariadb start

    echo "✅ MariaDB est prêt, création de l'utilisateur et de la base..."

    # Créer l'utilisateur et la base
    mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mariadb -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mariadb -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mariadb -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
    mariadb -e "FLUSH PRIVILEGES;"
    mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

    echo "✅ Configuration terminée. MariaDB attend les connexions."
    /etc/init.d/mariadb stop
fi
exec mariadbd --datadir=/var/lib/mysql