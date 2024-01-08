#!/bin/bash
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

UNAMEOUT="$(uname -s)"

WHITE='\033[1;37m'
NC='\033[0m'

IS_TTY=1
tty >/dev/null
if [[ 0 -ne $? ]]; then
    IS_TTY=0
fi

DOCKER_RUN_ADDIN=""
if [[ 0 -ne $IS_TTY ]];then
    DOCKER_RUN_ADDIN=" -it"
fi

# Verify operating system is supported...
case "${UNAMEOUT}" in
    Linux*)             MACHINE=linux;;
    Darwin*)            MACHINE=mac;;
    *)                  MACHINE="UNKNOWN"
esac

if [ "$MACHINE" == "UNKNOWN" ]; then
    echo "Unsupported operating system [$(uname -s)]. Laravel Sail supports macOS, Linux, and Windows (WSL2)." >&2

    exit 1
fi

# Source the ".env" file so Laravel's environment variables are available...
if [ -f ./.env ]; then
    source ./.env
fi

if ! [ -x "$(command -v docker-compose)" ]; then
    shopt -s expand_aliases
    alias docker-compose='docker compose'
fi

# Function that outputs Sail is not running...
function sail_is_not_running {
    echo -e "${WHITE}Sail is not running.${NC}" >&2
    echo "" >&2
    echo -e "${WHITE}You may Sail using the following commands:${NC} './vendor/bin/sail up' or './vendor/bin/sail up -d'" >&2

    exit 1
}

if [ -z "$SAIL_SKIP_CHECKS" ]; then
    # Ensure that Docker is running...
    if ! docker info > /dev/null 2>&1; then
        echo -e "${WHITE}Docker is not running.${NC}" >&2

        exit 1
    fi

    # Determine if Sail is currently up...
    PSRESULT="$(docker-compose ps -q)"
    if docker-compose ps | grep $APP_SERVICE | grep 'Exit'; then
        echo -e "${WHITE}Shutting down old Sail processes...${NC}" >&2

        docker-compose down > /dev/null 2>&1

        EXEC="no"
    elif [ -n "$PSRESULT" ]; then
        EXEC="yes"
    else
        EXEC="no"
    fi
else
    EXEC="yes"
fi

if [ $# -gt 0 ]; then
    # Extend the start command by starting the webpack-watcher
    if [ "$1" == "start" ]; then
        shift 1
        npm ci --legacy-peer-deps
        docker-compose up -d --remove-orphans "$@"
        kill -9 $(cat npm.pid) # kill previous process if any
        npm run watch >> /dev/null &
        echo $! > npm.pid
    # Extend the down command by killing npm as well
    elif [ "$1" == "down" ]; then
        shift 1
        docker-compose down "$@"
        kill -9 $(cat npm.pid)
    # Extend the kill command by killing npm as well
    elif [ "$1" == "kill" ]; then
        docker-compose kill
        kill -9 $(cat npm.pid)
    # Proxy PHP commands to the "php" binary on the application container...
    elif [ "$1" == "php" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                php "$@"
        else
            sail_is_not_running
        fi

    # proxy commands to process manager
    elif [ "$1" == "pm2" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                pm2 "$@"
        else
            sail_is_not_running
        fi

    # start cypress interactive via sail
    elif [ "$1" == "cypress" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            if (which npm); then
                npm run cypress-interactive
            else
                echo "npm not found. please install npm >= 8 and node >= 18"
            fi
        else
            sail_is_not_running
        fi



    # Proxy vendor binary commands on the application container...
    elif [ "$1" == "bin" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                ./vendor/bin/"$@"
        else
            sail_is_not_running
        fi

    # pass build arg UserID
    elif [ "$1" == "build" ]; then
                 shift 1
                 docker-compose build --build-arg UID=$(id -u) "$@"
                 exit
    # init stack
    elif [ "$1" == "init" ]; then
        shift 1
        ./bin/add_precommit_hook.sh
        docker-compose build --build-arg UID=$(id -u)
        docker-compose run -u "${SAIL_USER:=myswooop}" --entrypoint "composer install" "$APP_SERVICE"
        exit

    # phpinsights (phpinsights)
    elif [ "$1" == "phpinsights" ]; then
        shift 1
        docker run $DOCKER_RUN_ADDIN -v "$PWD":/analyze registry.myschubert.com/dev/quality-tool:8.2 phpinsights \
        --min-quality="$MIN_QUALITY" \
        --min-complexity="$MIN_COMPLEXITY" \
        --min-architecture="$MIN_ARCHITECTURE" \
        --min-style="$MIN_STYLE" \
        ${@:1}
        exit $?

    # phpformat (php-cs-fixer)
    elif [ "$1" == "phpformat" ]; then
        shift 1
        docker run $DOCKER_RUN_ADDIN -v $PWD:/analyze registry.myschubert.com/dev/quality-tool:8.2 fix-php ${@:1}
        exit $?

    # phpcheck stan (stan)
    elif [ "$1" == "phpcheck" ]; then
        shift 1
        docker run $DOCKER_RUN_ADDIN -v $PWD:/analyze registry.myschubert.com/dev/quality-tool:8.2 phpstan ${@:1}
        exit $?

    # tsformat (prettier)
    elif [ "$1" == "tsformat" ]; then
        shift 1
            npm run format ${@:-'resources/js/**/*.{ts,vue}' 'tests/ts/**/*.ts'}
        exit $?

    # tscheck (eslint)
    elif [ "$1" == "tscheck" ]; then
        shift 1
            npm run eslint-check ${@:-resources/js/ tests/ts/}
            npm run check-types
        exit $?

    # tsfix (eslint fix)
    elif [ "$1" == "tsfix" ]; then
        shift 1
            npm run eslint-fix ${@:-resources/js/ tests/ts/}
        exit $?

    # install all the things (npm and composer)
    elif [ "$1" == "install" ]; then
        shift 1
            npm ci  --legacy-peer-deps && \
            docker-compose exec -T -u "${SAIL_USER:=myswooop}" "$APP_SERVICE" composer install
        exit $?

    # Proxy Composer commands to the "composer" binary on the application container...
    elif [ "$1" == "composer" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                composer "$@"
        else
            sail_is_not_running
        fi

    # Proxy Artisan commands to the "artisan" binary on the application container...
    elif [ "$1" == "artisan" ] || [ "$1" == "art" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                php artisan "$@"
        else
            sail_is_not_running
        fi

    # Proxy the "phpunit" command to "php vendor/bin/phpunit"...
    elif [ "$1" == "phptest" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                php vendor/bin/phpunit "$@"
        else
            sail_is_not_running
        fi

    # Initiate a Laravel Tinker session within the application container...
    elif [ "$1" == "tinker" ] ; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                php artisan tinker
        else
            sail_is_not_running
        fi

    # Initiate a MySQL CLI terminal session within the "mariadb" container...
    elif [ "$1" == "mariadb" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                "${MARIA_SERVICE:=mariadb}" \
                bash -c 'MYSQL_PWD=${MYSQL_PASSWORD} mysql -u ${MYSQL_USER} ${MYSQL_DATABASE}'
        else
            sail_is_not_running
        fi

    # Initiate a Bash shell within the application container...
    elif [ "$1" == "shell" ] || [ "$1" == "ash" ]; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u "${SAIL_USER:=myswooop}" \
                "$APP_SERVICE" \
                ash "$@"
        else
            sail_is_not_running
        fi

    # Initiate a root user Bash shell within the application container...
    elif [ "$1" == "root-shell" ] ; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                -u root \
                "$APP_SERVICE" \
                ash "$@"
        else
            sail_is_not_running
        fi

    # Initiate a Redis CLI terminal session within the "redis" container...
    elif [ "$1" == "redis" ] ; then
        shift 1

        if [ "$EXEC" == "yes" ]; then
            docker-compose exec \
                "${REDIS_SERVICE:=redis}" \
                redis-cli
        else
            sail_is_not_running
        fi


    # Pass unknown commands to the "docker-compose" binary...
    else
        docker-compose "$@"
    fi
else
    docker-compose ps
fi
