#!/bin/bash

FILE=$1

docker-compose -f ../INTVOICE/docker-compose.test.yml up -d
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php vendor/bin/phpunit $FILE -c phpunit.xml"
docker-compose -f ../INTVOICE/docker-compose.test.yml stop
