#!/bin/bash

echo "Seeding Banking...."
docker-compose -f ../BANKING/docker-compose.yml exec banking-php sh -c "php artisan droptables --env=docker && php artisan migrate:refresh --seed --env=docker && php artisan l5:generate --env=docker"
echo "Seeding Intvoice...."
docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php sh -c "php artisan translations:frontend-dump && php artisan droptables --env=docker && php artisan migrate:refresh --seed --env=docker && php artisan l5:generate --env=docker"
