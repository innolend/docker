# Local env with Docker
## Basic configuration
- Copy `.env.example` to `.env` , by executing following command
```
cp .env.example .env
```
- Execute following command
```
docker-compose up -d
```
- Add aliases to yours hosts file
```
127.0.0.1 intvoice-docker.local banking-docker.local
127.0.0.1 test-intvoice-docker.local test-banking-docker.local
```

## List of available commands

##Intvoice
> ###Composer
> ```
> docker-compose run --rm intvoice-php composer
> ```
> ###Artisan
> ```
> docker-compose run --rm intvoice-php php artisan
> ```
> ###Gulp
> ```
> docker-compose run --rm intvoice-packages gulp
> ```
> ###Yarn
> ```
> docker-compose run --rm intvoice-packages yarn
> ```

##Banking
>  ###Composer
> ```
> docker-compose run --rm banking-php composer
> ```
> ###Artisan
> ```
> docker-compose run --rm banking-php php artisan
> ```
> ###Gulp
> ```
> docker-compose run --rm banking-packages gulp
> ```
> ###Yarn
> ```
> docker-compose run --rm banking-packages yarn
> ```

# Testing env with Docker
## basic configuration
- Open `.env` file and configure the path
- Execute following command
```
./docker_intvoice_acceptance_test_runner.sh
```
