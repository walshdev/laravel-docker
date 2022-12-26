# Include file with .env variables if exists
-include .env

# Define default values for variables
COMPOSE_FILE ?= docker-compose.yml

#-----------------------------------------------------------
# Management
#-----------------------------------------------------------

# Wake up docker containers
up:
	docker-compose up -d

# Shut down docker containers
down:
	docker-compose down

# Show a status of each container
status:
	docker-compose ps

# Status alias
ps: status

# Show logs of each container
logs:
	docker-compose logs

# Restart all containers
restart: down up

# Build containers
build:
	docker-compose -f ${COMPOSE_FILE} build

# Start containers
up:
	docker-compose -f ${COMPOSE_FILE} up -d

#-----------------------------------------------------------
# Logs
#-----------------------------------------------------------

# Clear file-based logs
logs-clear:
	sudo rm docker/dev/nginx/logs/*.log
	sudo rm docker/dev/supervisor/logs/*.log
	sudo rm src/storage/logs/*.log

#-----------------------------------------------------------
# Database
#-----------------------------------------------------------

# Dump database into file
db-dump:
	docker-compose exec -T postgres pg_dump -U app -d app > docker/postgres/dumps/dump.sql

#-----------------------------------------------------------
# Testing
#-----------------------------------------------------------

# Run phpunit tests
test:
	docker-compose exec -T php vendor/bin/phpunit --order-by=defects --stop-on-defect

# Run all tests ignoring failures.
test-all:
	docker-compose exec -T php vendor/bin/phpunit --order-by=defects

# Run phpunit tests with coverage
coverage:
	docker-compose exec -T php vendor/bin/phpunit --coverage-html tests/report

# Run phpunit tests
dusk:
	docker-compose exec -T php php artisan dusk

# Generate metrics
metrics:
	docker-compose exec -T php vendor/bin/phpmetrics --report-html=src/tests/metrics src/app

#-----------------------------------------------------------
# Tinker
#-----------------------------------------------------------

# Run tinker
tinker:
	docker-compose exec -T php php artisan tinker

#-----------------------------------------------------------
# Clearing
#-----------------------------------------------------------

# Shut down and remove all volumes
remove-volumes:
	docker-compose down --volumes

# Remove all existing networks (useful if network already exists with the same attributes)
prune-networks:
	docker network prune

# Clear cache
prune-a:
	docker system prune -a

#-----------------------------------------------------------
# Installation
#-----------------------------------------------------------

install: build up
	rm -rf src
	mkdir src
	docker-compose exec -T php composer create-project --prefer-dist laravel/laravel .
	sudo chown ${USER}:${USER} -R src
	sudo chmod -R 777 src/bootstrap/cache
	sudo chmod -R 777 src/storage
	sudo rm src/.env
	cp .env.example .env
	docker-compose exec -T php ln -s /var/www/.env /var/www/src
	docker-compose exec -T php php artisan key:generate --ansi
	docker-compose exec -T php composer require predis/predis
	docker-compose exec -T php php artisan --version
