#!/bin/bash

# Fix pour chroot_dir manquant
mkdir -p /var/run/vsftpd/empty

# Création de l'utilisateur FTP avec le mot de passe défini dans .env
adduser --disabled-password --gecos "" "$FTP_USER"
echo "$FTP_USER:$FT_PASS" | chpasswd

# Crée le dossier FTP s’il n’existe pas
mkdir -p /var/www/html

# Donne les bons droits à l’utilisateur FTP
chown -R "$FTP_USER":"$FTP_USER" /var/www/html

# Assure-toi que le home de l’utilisateur pointe bien sur le dossier FTP
usermod -d /var/www/html "$FTP_USER"

# Lance vsftpd avec la configuration personnalisée
exec /usr/sbin/vsftpd /etc/vsftpd.conf
