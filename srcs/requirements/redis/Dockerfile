FROM debian:bullseye

# Mise à jour du système et installation de Redis
RUN apt-get update && \
    apt-get install -y redis-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Commande de démarrage
CMD ["redis-server", "--bind", "0.0.0.0"]