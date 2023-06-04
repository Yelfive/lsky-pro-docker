FROM php:8.1.19-fpm-alpine3.16 as BASE

RUN apk add php8-pecl-imagick autoconf g++ make
RUN pecl install imagick

RUN docker-php-exc-install bcmath pdo_mysql

FROM php:8.1.19-fpm-alpine3.16

# Copy extension
COPY BASE:/usr/local/lib/php/extensions/no-debug-non-zts-20210902/* /usr/local/lib/php/extensions/no-debug-non-zts-20210902/
# Copy .ini
COPY ini/* /usr/local/etc/php/

RUN cp .env.example .env
RUN php artisan key:generate

CMD [php-fpm]