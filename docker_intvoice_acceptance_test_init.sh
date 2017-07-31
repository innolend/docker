#!/bin/bash

docker-compose -f ../INTVOICE/docker-compose.test.yml up -d
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan clear-compiled --env=docker.testing"
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan cache:clear --env=docker.testing"
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan translations:frontend-dump --env=docker.testing"
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan l5:generate --env=docker.testing"
docker-compose -f ../INTVOICE/docker-compose.test.yml exec test-intvoice-php sh -c "php artisan droptables --env=docker.testing && php artisan migrate:refresh --seed --env=docker.testing"
docker-compose -f ../INTVOICE/docker-compose.test.yml run --rm test-intvoice-packages gulp --production
