echo "Building composer"
docker-compose -f ../BANKING/docker-compose.yml run --rm banking-php sh -c "composer install"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-php sh -c "composer install"

echo "Building node modules && gulp"
docker-compose -f ../BANKING/docker-compose.yml run --rm banking-packages sh -c "yarn install"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-packages sh -c "yarn install && npm link node-sass && gulp"

echo "Rebuilding cache"
docker-compose -f ../BANKING/docker-compose.yml run --rm sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"