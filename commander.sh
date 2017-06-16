#!/bin/bash
DELAY=1

intvoice_menu() {
  clear
  echo "******************************************************"
  echo "* INTVOICE ENV                                       *"
  echo "******************************************************"
  echo "* 1 - Composer                                       *"
  echo "* 1a - Composer install                              *"
  echo "* 1b - Composer update --no-scripts                  *"
  echo "* 2 - Artisan                                        *"
  echo "* 2a - Artisan Migrate                               *"
  echo "* 2b - Artisan DB seed                               *"
  echo "* 2c - Artisan cache:clear                           *"
  echo "* 2d - Artisan route:clear                           *"
  echo "* 3 - Rebuild Gulp                                   *"
  echo "* 4 - Yarn                                           *"
  echo "* 5 - Rebuild Cache                                  *"
  echo "* 6 - Dump translations                              *"
  echo "* 7 - Back                                           *"
  echo "******************************************************"

  post_message() {
    read -p "Press enter to continue"
    intvoice_menu
  }

  read -p "Enter selection [1-7] > "

  if [[ $REPLY =~ ^[1-7]{1} ]]; then
    case $REPLY in
      1)
        read -p "Please enter the Composer command > "
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php composer $REPLY
        post_message
        ;;
      1a)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php composer install
        post_message
        ;;
      1b)

        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php composer update --no-scripts
        post_message
        ;;
      2)
        read -p "Please enter the Artisan command > "
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php php artisan $REPLY --env=docker
        post_message
        ;;
      2a)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php php artisan migrate --env=docker
        post_message
        ;;
      2b)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php php artisan db:seed --env=docker
        post_message
        ;;
      2c)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php php artisan cache:clear --env=docker
        post_message
        ;;
      2d)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php php artisan route:clear --env=docker
        post_message
        ;;
      3)
        echo "Processing Gulp...";
        docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-packages gulp
        post_message
        ;;
      4)
        read -p "Please enter the Yarn command > "
        docker-compose -f ../INTVOICE/docker-compose.yml run --rm intvoice-packages yarn $REPLY
        post_message
        ;;
      5)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
        ;;
      6)
        docker-compose -f ../INTVOICE/docker-compose.yml exec intvoice-php sh -c "php artisan translations:frontend-dump --env=docker"
        ;;
      7)
        local_env_menu
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    intvoice_menu
  fi
}

banking_menu() {
  clear
  echo "******************************************************"
  echo "* BANKING ENV                                        *"
  echo "******************************************************"
  echo "* 1 - Composer                                       *"
  echo "* 1a - Composer install                              *"
  echo "* 1b - Composer update --no-scripts                  *"
  echo "* 2 - Artisan                                        *"
  echo "* 2a - Artisan Migrate                               *"
  echo "* 2b - Artisan DB seed                               *"
  echo "* 2c - Artisan cache:clear                           *"
  echo "* 2d - Artisan route:clear                           *"
  echo "* 3 - Rebuild Cache                                  *"
  echo "* 4 - Build Swagger client                           *"
  echo "* 5 - Back                                           *"
  echo "******************************************************"

  post_message() {
    echo "\n\nFinished! Press any key"
    read a
    banking_menu
  }

  read -p "Enter selection [1-5] > "

  if [[ $REPLY =~ ^[1-5]{1} ]]; then
    case $REPLY in
      1)
        read -p "Please enter the Composer command > "
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php composer $REPLY
        post_message
        ;;
      2)
        read -p "Please enter the Artisan command > "
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php php artisan $REPLY
        post_message
        ;;
      1a)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php composer install
        post_message
        ;;
      1b)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php composer update --no-scripts
        post_message
        ;;
      2a)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php php artisan migrate --env=docker
        post_message
        ;;
      2b)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php php artisan db:seed --env=docker
        post_message
        ;;
      2c)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php php artisan cache:clear --env=docker
        post_message
        ;;
      2d)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php php artisan route:clear --env=docker
        post_message
        ;;
      3)
        docker-compose -f ../BANKING/docker-compose.yml run --rm sh -c "php artisan optimize --force && php artisan config:cache && php artisan route:cache"
        ;;
      4)
        docker-compose -f ../BANKING/docker-compose.yml exec banking-php php artisan l5-swagger:generate --env=docker
        docker run --rm -v ${PWD}/swagger:/local swaggerapi/swagger-codegen-cli generate \
            -i http://172.20.0.1:1180/docs/api-docs.json \
            -l php \
            -c /local/configs/banking-client-php.json \
            -o /local/out
        post_message
        ;;
      5)
        local_env_menu
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    banking_menu
  fi
}

verification_menu() {
  clear
  echo "******************************************************"
  echo "* VERIFICATION ENV                                       *"
  echo "******************************************************"
  echo "* 1 - Composer                                       *"
  echo "* 1a - Composer install                              *"
  echo "* 1b - Composer update --no-scripts                  *"
  echo "* 2 - Artisan                                        *"
  echo "* 2a - Artisan cache:clear                           *"
  echo "* 2b - Artisan route:clear                           *"
  echo "* 3 - Rebuild Gulp                                   *"
  echo "* 4 - Yarn                                           *"
  echo "* 5 - Back                                           *"
  echo "******************************************************"

  post_message() {
    read -p "Press enter to continue"
    verification_menu
  }

  read -p "Enter selection [1-5] > "

  if [[ $REPLY =~ ^[1-5]{1} ]]; then
    case $REPLY in
      1)
        read -p "Please enter the Composer command > "
        docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php composer $REPLY
        post_message
        ;;
      1a)
        docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php composer install
        post_message
        ;;
      1b)
        docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php composer update --no-scripts
        post_message
        ;;
      2)
        read -p "Please enter the Artisan command > "
        docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php php --env=docker artisan $REPLY
        post_message
        ;;
      2a)
        docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php php --env=docker artisan cache:clear
        post_message
        ;;
      2b)
        docker-compose -f ../VERIFICATION/docker-compose.yml exec verification-php php --env=docker artisan route:clear
        post_message
        ;;
      3)
        echo "Processing Gulp...";
        docker-compose -f ../VERIFICATION/docker-compose.yml run --rm verification-packages gulp
        post_message
        ;;
      4)
        read -p "Please enter the Yarn command > "
        docker-compose -f ../VERIFICATION/docker-compose.yml run --rm verification-packages yarn $REPLY
        post_message
        ;;
      5)
        local_env_menu
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    verification_menu
  fi
}

underwriter_menu() {
  clear
  echo "******************************************************"
  echo "* UNDERWRITER ENV                                    *"
  echo "******************************************************"
  echo "* 1 - Yarn                                           *"
  echo "* 2 - npm run dev                                    *"
  echo "******************************************************"

  post_message() {
    read -p "Press enter to continue"
    underwriter_menu
  }

  read -p "Enter selection [1-2] > "

  if [[ $REPLY =~ ^[1-2]{1} ]]; then
    case $REPLY in
      1)
        read -p "Please enter the Yarn command > "
        docker-compose -f ../UNDERWRITER/docker-compose.yml run --rm underwriter-packages yarn $REPLY
        post_message
        ;;
      2)
        docker-compose -f ../UNDERWRITER/docker-compose.yml run --rm underwriter-packages npm run dev
        post_message
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    underwriter_menu
  fi
}

test_env_menu() {
  clear
  echo "******************************************************"
  echo "* Test ENV                                           *"
  echo "******************************************************"
  echo "* 1 - Execute acceptiance tests                      *"
  echo "* 2 - Rebuild / Execute acceptiance tests            *"
  echo "* 3 - Turn off ENV                                   *"
  echo "* 4 - Back                                           *"
  echo "******************************************************"

  read -p "Enter selection [1-4] > "
  if [[ $REPLY =~ ^[1-4]$ ]]; then
    case $REPLY in
      1)
        echo "Running tests"
        sh ./docker_intvoice_acceptance_test_runner.sh
        ;;
      2)
        echo "Rebuilding env"
        docker-sync start
        docker-compose -f ../INTVOICE/docker-compose.test.yml stop
        docker-compose -f ../INTVOICE/docker-compose.test.yml rm -f
        docker-compose -f ../INTVOICE/docker-compose.test.yml pull
        docker-compose -f ../INTVOICE/docker-compose.test.yml up -d
        sh ./docker_intvoice_acceptance_test_runner.sh
        ;;
      3)
        docker-compose -f ../INTVOICE/docker-compose.test.yml stop
        read -p "Env stopped! Press enter to continue"
        ;;
      4)
        main_menu
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    test_env_menu
  fi
}

local_env_menu() {
  clear
  echo "******************************************************"
  echo "* Local ENV                                          *"
  echo "******************************************************"
  echo "* 1 - Build ENV                                      *"
  echo "* 2 - Update ENV                                     *"
  echo "* 3a - INTVOICE                                      *"
  echo "* 3b - BANKING                                       *"
  echo "* 3c - VERIFICATION                                  *"
  echo "* 3d - UNDERWRITER                                   *"
  echo "* 4 - Start ENV                                      *"
  echo "* 5 - Turn off ENV                                   *"
  echo "* 6 - Remove ENV                                     *"
  echo "* 7 - Back                                           *"
  echo "******************************************************"

  read -p "Enter selection [1-7] > "

  if [[ $REPLY =~ ^[1-7]{1} ]]; then
    case $REPLY in
      1)
        echo "Building ENV...";
        docker-compose -f ../INTVOICE/docker-compose.yml stop
        docker-compose -f ../BANKING/docker-compose.yml stop
        docker-compose -f ../VERIFICATION/docker-compose.yml stop
        docker-compose -f ../UNDERWRITER/docker-compose.yml stop
        docker-compose -f ../INTVOICE/docker-compose.yml rm -f
        docker-compose -f ../BANKING/docker-compose.yml rm -f
        docker-compose -f ../VERIFICATION/docker-compose.yml rm -f
        docker-compose -f ../UNDERWRITER/docker-compose.yml rm -f
        docker-sync clean
        sh ./docker_env_pre_build.sh
        sh ./docker_env_build.sh
        read -p "Press enter to continue"
        main_menu
        ;;
      2)
        echo "Updating ENV...";
        docker-compose -f ../INTVOICE/docker-compose.yml pull
        docker-compose -f ../BANKING/docker-compose.yml pull
        docker-compose -f ../VERIFICATION/docker-compose.yml pull
        docker-compose -f ../UNDERWRITER/docker-compose.yml pull
        read -p "Press enter to continue"
        main_menu
        ;;
      3a)
        intvoice_menu
        ;;
      3b)
        banking_menu
        ;;
      3c)
        verification_menu
        ;;
      3d)
        underwriter_menu
        ;;
      4)
        docker-sync start
        docker-compose -f ../INTVOICE/docker-compose.yml stop
        docker-compose -f ../BANKING/docker-compose.yml stop
        docker-compose -f ../VERIFICATION/docker-compose.yml stop
        docker-compose -f ../UNDERWRITER/docker-compose.yml stop
        docker-compose -f ../INTVOICE/docker-compose.yml up -d
        docker-compose -f ../BANKING/docker-compose.yml up -d
        docker-compose -f ../VERIFICATION/docker-compose.yml up -d
        docker-compose -f ../UNDERWRITER/docker-compose.yml up -d
        echo "INTVOICE available on http://localhost:80";
        echo "BANKING available on http://localhost:1180";
        echo "VERIFICATION available on http://localhost:1280";
        read -p "Env started! Press enter to continue"
        local_env_menu
        ;;
      5)
        docker-compose -f ../INTVOICE/docker-compose.yml stop
        docker-compose -f ../BANKING/docker-compose.yml stop
        docker-compose -f ../VERIFICATION/docker-compose.yml stop
        docker-compose -f ../UNDERWRITER/docker-compose.yml stop
        docker-sync stop
        read -p "Env stopped! Press enter to continue"
        local_env_menu
        ;;
      6)
        docker-compose -f ../INTVOICE/docker-compose.yml stop
        docker-compose -f ../BANKING/docker-compose.yml stop
        docker-compose -f ../VERIFICATION/docker-compose.yml stop
        docker-compose -f ../UNDERWRITER/docker-compose.yml stop
        docker-compose -f ../INTVOICE/docker-compose.yml rm -f
        docker-compose -f ../BANKING/docker-compose.yml rm -f
        docker-compose -f ../VERIFICATION/docker-compose.yml rm -f
        docker-compose -f ../UNDERWRITER/docker-compose.yml rm -f
        docker-sync clean
        read -p "Env removed! Press enter to continue"
        local_env_menu
        ;;
      7)
        main_menu
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    local_env_menu
  fi
}

main_menu() {
  clear
  echo "******************************************************"
  echo "* Welcome, to the Innolend env commander             *"
  echo "******************************************************"
  echo "* Please select an action                            *"
  echo "******************************************************"
  echo "* 1 - working with local env                         *"
  echo "* 2 - working with test env                          *"
  echo "* 3 - prepare packages list (file 'packages.list')   *"
  echo "* 4 - exit                                           *"
  echo "******************************************************"

  read -p "Enter selection [1-4] > "

  if [[ $REPLY =~ ^[1-4]$ ]]; then
    case $REPLY in
      1)
        local_env_menu
        ;;
      2)
        test_env_menu
        ;;
      3)
        rm -f packages.list
        cat ../INTVOICE/yarn.lock | grep 'https://' | awk '{ print $2 }' | sed 's/"//g' > ./packages.list
        echo "File stored in same folder as commander and called 'packages.list'"
        read -p "Press enter to continue"
        main_menu
        ;;
      4)
        clear
        exit 0
        ;;
    esac
  else
    echo "Invalid entry."
    sleep $DELAY
    main_menu
  fi
}

# while :
# do
  clear
  main_menu
# done
