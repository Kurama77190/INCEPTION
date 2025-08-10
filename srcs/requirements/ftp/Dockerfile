FROM debian:bullseye

# Mise à jour et installation de vsftpd uniquement (pas besoin de 'ftp' ici)
RUN apt update && \
    apt install -y vsftpd && \
    apt clean

# Copie du fichier de configuration et du script de setup
COPY ./tools/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/setup.sh /setup.sh

# Donne les droits d'exécution au script
RUN chmod +x /setup.sh

# Démarre vsftpd via setup.sh
ENTRYPOINT ["/setup.sh"]