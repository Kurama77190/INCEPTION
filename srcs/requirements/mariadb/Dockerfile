FROM debian:bullseye

# 1. Met à jour les paquets et installe MariaDB
RUN apt-get update && apt-get install -y mariadb-server

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld

# 2. Copie du fichier de configuration de mariadb
COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# 3. copie le script de l'image modifier de mariadb
COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# 4. Lance MariaDB proprement

ENTRYPOINT ["/setup.sh"]
