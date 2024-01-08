FROM registry.myschubert.com/base-images/php8.2.swoole

ENV APP_NAME="Email Api Service"
ENV APP_URL="https://email-api-service.myswooop.de"

USER root

RUN mkdir -p /filebeat \
    && cd /tmp \
    && curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.17.3-linux-x86_64.tar.gz \
    && tar xzvf filebeat-7.17.3-linux-x86_64.tar.gz  --strip-components=1 --directory /filebeat \
    && rm filebeat-7.17.3-linux-x86_64.tar.gz \
    && apk add --no-cache libc6-compat curl jq \
    && chown -R myswooop:myswooop /filebeat

COPY --chown=myswooop:myswooop ./docker/config/filebeat.yml /filebeat/laravel.yml

USER myswooop

COPY --chown=myswooop:myswooop ./composer.json /var/www/app/composer.json
COPY --chown=myswooop:myswooop ./composer.lock /var/www/app/composer.lock

ARG GITLAB_TOKEN

RUN mkdir -p ~/.composer \
    && composer config --global http-basic.gitlab.myschubert.com "__token__" "$GITLAB_TOKEN" \
    && composer install --no-dev --prefer-dist --no-scripts --no-autoloader

COPY --chown=myswooop:myswooop ./package.json /var/www/app/package.json
COPY --chown=myswooop:myswooop ./package-lock.json /var/www/app/package-lock.json

RUN npm ci

COPY --chown=myswooop:myswooop ./app /var/www/app/app
COPY --chown=myswooop:myswooop ./bootstrap /var/www/app/bootstrap
COPY --chown=myswooop:myswooop ./config /var/www/app/config
COPY --chown=myswooop:myswooop ./database /var/www/app/database
COPY --chown=myswooop:myswooop ./ecosystems /var/www/app/ecosystems
COPY --chown=myswooop:myswooop ./public /var/www/app/public
COPY --chown=myswooop:myswooop ./storage /var/www/app/storage
COPY --chown=myswooop:myswooop ./artisan /var/www/app/artisan
COPY --chown=myswooop:myswooop ./CHANGELOG.md /var/www/app/CHANGELOG.md
COPY --chown=myswooop:myswooop ./README.md /var/www/app/README.md

RUN composer dump-autoload -a --no-dev
