#!/bin/bash

FILE=$1

echo "Running tests"
docker-compose -f ../INTVOICE/docker-compose.test.yml run test-intvoice-php php vendor/codeception/codeception/codecept run $FILE --env=docker.testing