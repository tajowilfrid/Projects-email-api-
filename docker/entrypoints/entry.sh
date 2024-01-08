#!/bin/sh

_term() {
  # on shutdown
  pm2 stop all
  pm2 kill
}

# shellcheck disable=SC2039
trap _term SIGTERM
# shellcheck disable=SC2039
trap _term SIGINT

export CONTAINER_ID="$(cat /proc/1/cpuset | cut -c9-)"

echo "VERSION: $VERSION"

# dispatch process manager daemon and start it
if [[ $APP_ENV =~ "production" ]]; then
    composer dump-autoload -a
    pm2 start docker/config/pm2/ecosystem.boot.prod.json
    pm2 start docker/config/pm2/ecosystem.web.prod.json
    pm2 start docker/config/pm2/ecosystem.jobs.prod.json
else
    pm2 start docker/config/pm2/ecosystem.boot.dev.json
    pm2 start docker/config/pm2/ecosystem.web.dev.json
fi

pm2 logs