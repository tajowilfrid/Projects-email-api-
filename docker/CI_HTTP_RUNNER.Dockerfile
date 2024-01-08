FROM registry.myschubert.com/base-images/php8.2.swoole.dev

ENV APP_NAME="Transaction AUDIT Service"

ENV APP_URL="https://email-api-service.localhost"

USER root

RUN apk add --no-cache openjdk17 bash
RUN curl -f -L -o ijhttp.zip "https://jb.gg/ijhttp/latest" \
    && unzip ijhttp.zip \
    && mv ijhttp /opt/ijhttp \
    && rm ijhttp.zip \
    && chmod a+x /opt/ijhttp/ijhttp

USER myswooop