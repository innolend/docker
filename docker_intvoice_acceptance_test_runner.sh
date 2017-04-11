#!/bin/bash

FILE=$1
echo "Turn off all test containers"
docker-compose -f docker-compose.test.yml stop
docker-compose -f docker-compose.test.yml rm -f
docker-compose -f docker-compose.test.yml up -d
echo "Waiting for data servers will able to recieve connections"
sleep 30

echo "Refill banking test database"
docker-compose -f docker-compose.test.yml run test-banking-php sh -c "php artisan droptables --env=docker.testing && php artisan migrate --env=docker.testing && php artisan db:seed --env=docker.testing"
docker-compose -f docker-compose.test.yml stop

echo "Refill intvoice test database"

docker-compose -f docker-compose.test.yml run test-intvoice-php sh -c "php artisan droptables --env=docker.testing && php artisan migrate --env=docker.testing && php artisan db:seed --env=docker.testing"
docker-compose -f docker-compose.test.yml stop

echo "Running tests"
docker-compose -f docker-compose.test.yml run test-intvoice-php php vendor/codeception/codeception/codecept run $FILE --env=docker.testing