#!/bin/bash

FILE=$1

echo "Running tests"
docker-compose -f ../INTVOICE/docker-compose.test.yml up -d && docker-compose -f ../INTVOICE/docker-compose.test.yml run --rm test-intvoice-php sh -c "php vendor/codeception/codeception/codecept run $FILE --env=docker.testing"