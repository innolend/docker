#!/bin/bash

docker-compose -f ../INTVOICE/docker-compose.test.yml up -d
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan clear-compiled"
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan cache:clear"
docker-compose -f ../INTVOICE/docker-compose.test.yml run --rm test-intvoice-packages gulp --production
