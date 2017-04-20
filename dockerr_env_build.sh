echo "Stop previous version"
docker-compose stop
echo "Remove previous version"
docker-compose rm -f
echo "Update containers"
docker-compose pull
echo "Execute laravel seed"
docker-compose up -d
echo "Waiting until servers will be ready to recieve connections"
sleep 20
docker-compose run banking-php sh -c "php artisan droptables --env=docker && php artisan migrate --env=docker && php artisan db:seed --env=docker && php artisan l5:generate"
source .env
echo "Generating API KEY"
API_TOKEN="$(docker-compose run intvoice-php php artisan --env=docker get_banking_key --key=foo-api-key --password=lalelu123)"
echo "Setting API KEY to: ${API_TOKEN}"
cp ${INTVOICE_PATH}/.env.docker ${INTVOICE_PATH}/.env.bak
sed "s/^BANKING_API_TOKEN=.*/BANKING_API_TOKEN=${API_TOKEN}/g" "${INTVOICE_PATH}/.env.bak" > ${INTVOICE_PATH}/.env.docker
cp ${INTVOICE_PATH}/.env.docker.testing ${INTVOICE_PATH}/.env.testing.bak
sed "s/^BANKING_API_TOKEN=.*/BANKING_API_TOKEN=${API_TOKEN}/g" "${INTVOICE_PATH}/.env.testing.bak" > ${INTVOICE_PATH}/.env.docker.testing
echo "Start working with INTVOICE"
docker-compose run intvoice-php sh -c "php artisan translations:frontend-dump && php artisan droptables --env=docker && php artisan migrate --env=docker && php artisan db:seed --env=docker && php artisan l5:generate --env=docker"
docker-compose run intvoice-packages sh -c "gulp"