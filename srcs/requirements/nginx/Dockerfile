FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*  

RUN apt-get update && apt-get install procps -y

RUN mkdir -p /etc/nginx/certs

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/selfsigned.crt /etc/nginx/certs/selfsigned.crt
COPY conf/selfsigned.key /etc/nginx/certs/selfsigned.key

EXPOSE 443

CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
# CMD ["nginx", "-g", "daemon off;"]