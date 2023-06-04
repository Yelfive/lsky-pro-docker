FROM php:8.1.19-fpm-alpine3.16 AS BASE

RUN apk add php8-pecl-imagick autoconf g++ make imagemagick imagemagick-dev
RUN pecl install imagick
RUN docker-php-ext-enable imagick

RUN docker-php-ext-install bcmath pdo_mysql

FROM php:8.1.19-fpm-alpine3.16

ENV LSKY_VERSION=LSKY_VERSION_CHANGE_ME

# Copy extension
COPY --from=BASE /usr/local/lib/php/extensions/no-debug-non-zts-20210902/* /usr/local/lib/php/extensions/no-debug-non-zts-20210902/
# Copy *.ini
COPY --from=BASE /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d/

USER www-data

ADD https://github.com/lsky-org/lsky-pro/releases/download/${LSKY_VERSION}/lsky-pro-${LSKY_VERSION}.zip /var/www/html

RUN unzip lsky-pro-${LSKY_VERSION}.zip && rm lsky-pro-${LSKY_VERSION}.zip

WORKDIR /var/www/html

RUN cp .env.example .env
RUN php artisan key:generate

CMD ["php-fpm"]
