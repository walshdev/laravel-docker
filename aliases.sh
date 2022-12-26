# Execute command from the app container by the current user
alias php='docker-compose exec --user "$(id -u):$(id -g)" php'

# Execute command from specified container
alias from='docker-compose exec'

# Execute command from specified container by the current user
alias owning='docker-compose exec --user "$(id -u):$(id -g)"'

# Run artisan commands
alias artisan='docker-compose exec --user "$(id -u):$(id -g)" php php artisan'

# Testing aliases
alias test='docker-compose exec php vendor/bin/phpunit'
alias tf='docker-compose exec php vendor/bin/phpunit --filter'
alias ts='docker-compose exec php vendor/bin/phpunit --testsuite'

# Execute command from specified container
alias logs='docker-compose logs'

alias composer='docker-compose exec php composer'
