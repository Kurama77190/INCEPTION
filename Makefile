DOCKER_COMPOSE=docker compose
COMPOSE_FILE=srcs/docker-compose.yml
DATA=/home/sben-tay/data/

all:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up --build
	sudo mkdir -p $(DATA)wordpress $(DATA)mariadb

re: fclean all

clean:
	$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down -v --remove-orphans

fclean: clean
	docker system prune -fa
	sudo rm -rf $(DATA)

.PHONY: all re clean fclean