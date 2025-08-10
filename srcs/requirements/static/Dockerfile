FROM debian:bullseye

RUN apt update && apt install -y python3

WORKDIR /var/www/html
COPY ./html .

CMD ["python3", "-m", "http.server", "80"]
