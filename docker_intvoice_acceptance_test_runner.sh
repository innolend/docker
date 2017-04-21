#!/bin/bash

FILE=$1

echo "Running tests"
docker-compose -f ../INTVOICE/docker-compose.test.yml stop
docker-compose -f ../INTVOICE/docker-compose.test.yml rm
docker-compose -f ../INTVOICE/docker-compose.test.yml up -d
sleep 10
docker-compose -f ../INTVOICE/docker-compose.test.yml run --rm test-intvoice-php php vendor/codeception/codeception/codecept run $FILE --env=docker.testing