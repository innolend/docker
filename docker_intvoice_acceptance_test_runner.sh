#!/bin/bash

FILE=$1
echo "Turn off all test containers"
docker-compose -f ../INTVOICE/docker-compose.test.yml stop
docker-compose -f ../INTVOICE/docker-compose.test.yml rm -f
docker-compose -f ../INTVOICE/docker-compose.test.yml up -d
echo "Waiting for data servers will able to recieve connections"
sleep 30

docker-compose -f ../INTVOICE/docker-compose.test.yml stop

echo "Running tests"
docker-compose -f ../INTVOICE/docker-compose.test.yml run test-intvoice-php php vendor/codeception/codeception/codecept run $FILE --env=docker.testing