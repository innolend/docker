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
  echo "* 5 - Back                                           *"
  echo "******************************************************"

  post_message() {
    read -p "Press enter to continue"
    intvoice_menu    
  }

  read -p "Enter selection [1-5] > "

  if [[ $REPLY =~ ^[1-5]{1} ]]; then
    case $REPLY in
      1)
        read -p "Please enter the Composer command > "
        docker-compose run --rm intvoice-php composer $REPLY
        post_message
        ;;
      1a)
        docker-compose run --rm intvoice-php composer install
        post_message
        ;;
      1b)
        docker-compose run --rm intvoice-php composer update --no-scripts  
        post_message
        ;;
      2)
        read -p "Please enter the Artisan command > "
        docker-compose run --rm intvoice-php php artisan $REPLY
        post_message
        ;;
      2a)
        docker-compose run --rm intvoice-php php artisan migrate
        post_message
        ;;
      2b)
        docker-compose run --rm intvoice-php php artisan db:seed
        post_message
        ;;
      2c)
        docker-compose run --rm intvoice-php php artisan cache:clear
        post_message
        ;;
      2d)
        docker-compose run --rm intvoice-php php artisan route:clear
        post_message
        ;;
      3)
        echo "Processing Gulp...";
        docker-compose run --rm intvoice-packages gulp
        post_message
        ;;
      4)
        read -p "Please enter the Yarn command > "
        docker-compose run --rm intvoice-packages yarn $REPLY
        post_message
        ;;
      5)
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
  echo "* 3 - Rebuild Gulp                                   *"
  echo "* 4 - Yarn                                           *"
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
        docker-compose run --rm banking-php composer $REPLY
        post_message
        ;;
      2)
        read -p "Please enter the Artisan command > "
        docker-compose run --rm banking-php php artisan $REPLY
        post_message
        ;;
      1a)
        docker-compose run --rm banking-php composer install
        post_message
        ;;
      1b)
        docker-compose run --rm banking-php composer update --no-scripts  
        post_message
        ;;
      2a)
        docker-compose run --rm banking-php php artisan migrate
        post_message
        ;;
      2b)
        docker-compose run --rm banking-php php artisan db:seed
        post_message
        ;;
      2c)
        docker-compose run --rm banking-php php artisan cache:clear
        post_message
        ;;
      2d)
        docker-compose run --rm banking-php php artisan route:clear
        post_message
        ;;
      3)
        echo "Processing Gulp...";
        docker-compose run --rm banking-packages gulp
        post_message
        ;;
      4)
        read -p "Please enter the Yarn command > "
        docker-compose run --rm banking-packages yarn $REPLY
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

test_env_menu() {
  clear
  echo "******************************************************"
  echo "* Test ENV                                           *"
  echo "******************************************************"
  echo "* 1 - Execute acceptiance tests                      *"
  echo "* 2 - Back                                           *"
  echo "******************************************************"
  read -p "Enter selection [1-2] > "
  if [[ $REPLY =~ ^[1-2]$ ]]; then
    case $REPLY in
      1)
        echo "Running tests"
        sh ./docker_intvoice_acceptance_test_runner.sh
        ;;
      2)
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
  echo "* 3 - INTVOICE                                       *"
  echo "* 4 - BANKING                                        *"
  echo "* 5 - Start ENV                                      *"
  echo "* 6 - Turn off ENV                                   *"
  echo "* 7 - Remove ENV                                     *"
  echo "* 8 - Back                                           *"
  echo "******************************************************"

  read -p "Enter selection [1-8] > "

  if [[ $REPLY =~ ^[1-8]$ ]]; then
    case $REPLY in
      1)
        echo "Building ENV...";
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
        docker-compose run banking-php sh -c "composer install && php artisan droptables && php artisan migrate && php artisan db:seed && php artisan l5:generate"
        docker-compose run intvoice-php sh -c "composer install && php artisan droptables && php artisan migrate && php artisan db:seed && php artisan l5:generate"
        read -p "Press enter to continue"
        main_menu
        ;;
      2)
        echo "Updating ENV...";
        docker-compose pull

        read -p "Press enter to continue"
        main_menu
        ;;
      3)
        intvoice_menu
        ;;
      4)
        banking_menu
        ;;
      5)
        docker-compose up -d
        read -p "Env started! Press enter to continue"
        local_env_menu
        ;;
      6)
        docker-compose stop
        read -p "Env stopped! Press enter to continue"
        local_env_menu
        ;;
      7)
        docker-compose stop
        docker-compose rm -f
        read -p "Env removed! Press enter to continue"
        local_env_menu
        ;;
      8)
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
  echo "* 3 - exit                                           *"
  echo "******************************************************"

  read -p "Enter selection [1-3] > "

  if [[ $REPLY =~ ^[1-3]$ ]]; then
    case $REPLY in
      1)
        local_env_menu
        ;;
      2)
        test_env_menu
        ;;
      3)
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