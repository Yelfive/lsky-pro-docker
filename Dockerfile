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

COPY --from=BASE                                /usr/lib/libXau.so.6.0.0    /usr/lib/libexpat.so.1.8.10       /usr/lib/liblcms2.so.2.0.13 \
    /usr/lib/libMagickCore-7.Q16HDRI.so.10      /usr/lib/libXdmcp.so.6      /usr/lib/libfontconfig.so.1       /usr/lib/libltdl.so.7 \
    /usr/lib/libMagickCore-7.Q16HDRI.so.10.0.0  /usr/lib/libXdmcp.so.6.0.0  /usr/lib/libfontconfig.so.1.12.0  /usr/lib/libltdl.so.7.3.2 \
    /usr/lib/libMagickWand-7.Q16HDRI.so.10      /usr/lib/libXext.so.6       /usr/lib/libfreetype.so.6         /usr/lib/libpng16.so.16 \
    /usr/lib/libMagickWand-7.Q16HDRI.so.10.0.0  /usr/lib/libXext.so.6.4.0   /usr/lib/libfreetype.so.6.18.3    /usr/lib/libpng16.so.16.37.0 \
    /usr/lib/libX11.so.6                        /usr/lib/libbz2.so.1        /usr/lib/libgomp.so.1             /usr/lib/libxcb.so.1 \
    /usr/lib/libX11.so.6.4.0                    /usr/lib/libbz2.so.1.0.8    /usr/lib/libgomp.so.1.0.0         /usr/lib/libxcb.so.1.1.0 \
    /usr/lib/libXau.so.6                        /usr/lib/libexpat.so.1      /usr/lib/liblcms2.so.2 \
    /usr/lib

USER www-data

ADD --chown=data:www-data https://github.com/lsky-org/lsky-pro/releases/download/${LSKY_VERSION}/lsky-pro-${LSKY_VERSION}.zip /var/www/html

RUN unzip lsky-pro-${LSKY_VERSION}.zip && rm lsky-pro-${LSKY_VERSION}.zip

WORKDIR /var/www/html

RUN cp .env.example .env
RUN php artisan key:generate

CMD ["php-fpm"]
