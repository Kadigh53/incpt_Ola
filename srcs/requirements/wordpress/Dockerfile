FROM debian:bullseye

RUN apt-get update  \
    && apt-get install -y wget php7.4 php7.4-fpm php7.4-mysql netcat \
    && mkdir -p /run/php && chmod -R 755 /run/php  && chown -R www-data:www-data /run/php

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
RUN chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/wp_config.sh /var/www/wordpress/wp_config.sh

WORKDIR /var/www/wordpress

EXPOSE  9000

ENTRYPOINT [ "/var/www/wordpress/wp_config.sh" ]
