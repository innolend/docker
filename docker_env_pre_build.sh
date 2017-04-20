echo "Building composer"
docker-compose run banking-php sh -c "composer install"
docker-compose run intvoice-php sh -c "composer install"

echo "Building node modules && gulp"
docker-compose run banking-packages sh -c "yarn && gulp"
docker-compose run intvoice-packages sh -c "yarn && gulp"