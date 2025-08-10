FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    gnupg2 \
    software-properties-common \
    wget \
    curl \
    adduser \
    libfontconfig1 \
    ca-certificates

# Ajouter la clé GPG de Grafana
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg

# Ajouter le dépôt Grafana stable
RUN echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
    > /etc/apt/sources.list.d/grafana.list

# Installer Grafana
RUN apt-get update && apt-get install -y grafana=10.4.1

CMD ["/usr/sbin/grafana-server", "--homepath=/usr/share/grafana", "--config=/etc/grafana/grafana.ini"]
