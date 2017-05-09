echo "Pre run containers"
docker-compose -f ../BANKING/docker-compose.yml up -d
docker-compose -f ../INTVOICE/docker-compose.yml up -d
docker-compose -f ../VERIFICATION/docker-compose.yml up -d

echo "Building composer"
docker-compose -f ../BANKING/docker-compose.yml exec banking-php sh -c "composer install"
docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php sh -c "composer install"
docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php sh -c "composer install"

echo "Building node modules && gulp"
docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-packages sh -c "yarn add node-sass && yarn install && gulp"
docker-compose -f ../VERIFICATION/docker-compose.yml exec intvoice-packages sh -c "yarn add node-sass && yarn install && gulp"
docker-compose -f ../UNDERWRITER/docker-compose.yml exec intvoice-packages sh -c "yarn install"

echo "Rebuilding cache"
docker-compose -f ../BANKING/docker-compose.yml exec banking-php sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
