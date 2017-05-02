echo "Building composer"
docker-compose -f ../BANKING/docker-compose.yml run banking-php sh -c "composer install"
docker-compose -f ../INTVOICE/docker-compose.yml run intvoice-php sh -c "composer install"
docker-compose -f ../VERIFICATION/docker-compose.yml run verification-php sh -c "composer install"

echo "Building node modules && gulp"
docker-compose -f ../BANKING/docker-compose.yml run banking-packages sh -c "yarn"
docker-compose -f ../INTVOICE/docker-compose.yml run intvoice-packages sh -c "yarn add node-sass && yarn add gulp-sass && yarn && gulp"
docker-compose -f ../VERIFICATION/docker-compose.yml run verification-packages sh -c "yarn add node-sass && yarn add gulp-sass && yarn && gulp"
docker-compose -f ../UNDERWRITER/docker-compose.yml run underwriter-packages sh -c "yarn"


echo "Rebuilding cache"
docker-compose -f ../BANKING/docker-compose.yml run --rm sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
docker-compose -f ../VERIFICATION/docker-compose.yml run --rm sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
