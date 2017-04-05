#!/bin/bash

intvoice_menu() {
  clear
  echo "----------------------------------------------------"
  echo "INTVOICE ENV"
  echo "----------------------------------------------------"
  echo "1 - Composer"
  echo "2 - Artisan"
  echo "3 - Rebuild Gulp"
  echo "4 - Yarn"
  echo "5 - Back"

  read action

  clear

  post_message() {
    echo "\n\nFinished! Press any key"
    read a
    intvoice_menu    
  }

  case $action in
    1)
      echo "Please enter the Composer command:"
      read cmd

      docker-compose run --rm intvoice-php composer $cmd

      post_message
      ;;
    2)
      echo "Please enter the Artisan command:"
      read cmd

      docker-compose run --rm intvoice-php php artisan $cmd

      post_message
      ;;
    3)
      docker-compose run --rm intvoice-packages gulp
      post_message
      ;;
    4)
      echo "Please enter the Yarn command:"
      read cmd

      docker-compose run --rm intvoice-packages yarn $cmd

      post_message
      ;;
    5)
      local_env_menu
      ;;
    *)
      intvoice_menu
      ;;
  esac
}

banking_menu() {
  clear
  echo "----------------------------------------------------"
  echo "BANKING ENV"
  echo "----------------------------------------------------"
  echo "1 - Composer"
  echo "2 - Artisan"
  echo "3 - Rebuild Gulp"
  echo "4 - Yarn"
  echo "5 - Back"

  read action

  clear

  post_message() {
    echo "\n\nFinished! Press any key"
    read a
    banking_menu    
  }

  case $action in
    1)
      echo "Please enter the Composer command:"
      read cmd

      docker-compose run --rm banking-php composer $cmd

      post_message
      ;;
    2)
      echo "Please enter the Artisan command:"
      read cmd

      docker-compose run --rm banking-php php artisan $cmd

      post_message
      ;;
    3)
      docker-compose run --rm banking-packages gulp
      post_message
      ;;
    4)
      echo "Please enter the Yarn command:"
      read cmd

      docker-compose run --rm banking-packages yarn $cmd

      post_message
      ;;
    5)
      local_env_menu
      ;;
    *)
      banking_menu
      ;;
  esac
}

local_env_menu() {
  clear
  echo "----------------------------------------------------"
  echo "Local ENV"
  echo "----------------------------------------------------"
  echo "1 - Build ENV"
  echo "2 - Update ENV"
  echo "3 - INTVOICE"
  echo "4 - BANKING"
  echo "5 - Back"

  read action

  case $action in
    1)
      echo "Building ENV...";
      docker-compose run banking-php php artisan droptables
      docker-compose run banking-php php artisan migrate
      docker-compose run banking-php php artisan db:seed
      docker-compose run intvoice-php php artisan droptables
      docker-compose run intvoice-php php artisan migrate
      docker-compose run intvoice-php php artisan db:seed

      echo "\n\n\nENV Builed!!! Press any key"
      read a
      main_menu
      ;;
    2)
      echo "Updating ENV...";
      docker-compose pull

      echo "\n\n\nNew Docker images pulled!!! Press any key"
      read a
      main_menu
      ;;
    3)
      intvoice_menu
      ;;
    4)
      banking_menu
      ;;
    5)
      main_menu
      ;;
    *)
      local_env_menu
      ;;
  esac
}

main_menu() {
  clear
  echo "----------------------------------------------------"
  echo "Welcome, to the Innolend env commander"
  echo "----------------------------------------------------"
  echo "Please select an action"
  echo "----------------------------------------------------"
  echo "1 - working with local env"
  echo "2 - working with test env"
  echo "3 - exit"
  echo "----------------------------------------------------"

  read action

  case $action in
    1)
      local_env_menu
      ;;
    2)
      echo "Testing env"
      ;;
    3)
      clear
      exit 0
      ;;
    *)
      main_menu
      ;;
  esac
}

# while :
# do
  clear
  main_menu
# done