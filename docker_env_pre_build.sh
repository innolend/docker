echo "Building composer"

docker-compose -f ../BANKING/docker-compose.yml run --rm banking-php sh -c "composer install"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-php sh -c "composer install"
docker-compose -f ../VERIFICATION/docker-compose.yml run --rm verification-php sh -c "composer install"

echo "Building node modules && gulp"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-packages sh -c "yarn install && npm link node-sass && gulp"
docker-compose -f ../VERIFICATION/docker-compose.yml run --rm intvoice-packages sh -c "yarn install && npm link node-sass && ln -s /opt/project/node_modules/node-sass/vendor /opt/project/node_modules/laravel-elixir/node_modules/node-sass/vendor && ln -s /opt/project/node_modules/laravel-elixir/node_modules/node-sass/vendor/linux_musl-x64-51 /opt/project/node_modules/laravel-elixir/node_modules/node-sass/vendor/linux-x64-51 && yarn add sass-material-colors && gulp"
docker-compose -f ../UNDERWRITER/docker-compose.yml run --rm intvoice-packages sh -c "yarn"

echo "Rebuilding cache"
docker-compose -f ../BANKING/docker-compose.yml run --rm banking-php sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-php sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
