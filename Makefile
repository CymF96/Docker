# Variables
COMPOSE = docker compose -f srcs/docker-compose.yaml
PROJECT_NAME = inception

# Build and start the containers
up:
	@echo "building containers from $(PROJECT_NAME)"
	@mkdir -p /home/cofische/data/mariadb
	@mkdir -p /home/cofische/data/wordpress
	@$(COMPOSE) -p $(PROJECT_NAME) up --build -d

# Stop and remove the containers
stop:
	@echo "stopping containers from $(PROJECT_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) stop

# Stop and remove the containers and volumes
down:
	@echo "stopping containers and removing volumes from $(PROJECT_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) down --volumes

# Restart the services
restart: down up
	@echo "restarting containers from $(PROJECT_NAME)"

# Show running containers
ps:
	@echo "showing running containers"
	@$(COMPOSE) -p $(PROJECT_NAME) ps

# View logs of services
logs:
	@echo "showing containers' logs"
	@$(COMPOSE) -p $(PROJECT_NAME) logs -f

# Build individual container
nginx_up:
	@echo "building nginx"
	@mkdir -p /home/cofische/data/wordpress
	@mkdir -p /home/cofische/data/wordpress
	@$(COMPOSE) up --build nginx

db_ep:
	@echo "building mariadb"
	@mkdir -p /home/cofische/data/mariadb
	@$(COMPOSE) up --build mariadb

wp_up:
	@echo "building wordpress"
	@mkdir -p /home/cofische/data/wordpress
	@mkdir -p /home/cofische/data/wordpress
	@$(COMPOSE) up --build wordpress

# Run a shell inside the Nginx container
sh-nginx:
	@echo "accessing nginx"
	@docker exec -it nginx bash

sh-db:
	@echo "accessing mariadb"
	@docker exec -it mariadb bash

sh-wp:
	@echo "accessing wordpress"
	@docker exec -it wordpress bash

# Clean unused images and containers
clean:
	@echo "removing containers from $(PROJECT_NAME)"
	@$(COMPOSE) -p $(PROJECT_NAME) down --volumes

fclean: clean
	@echo "removing containers' unused images and cleaning volumes"
	@rm -rf "/home/cofische/data/*"
	@docker system prune -a --volumes -f

.PHONY: up down stop restart ps logs up-nginx up-db up-wp sh-nginx sh-db sh-wp clean fclean