FROM debian:bullseye-slim 

RUN apt-get update  \
    && apt-get install -y wget \
    && apt-get install -y php7.4 php7.4-fpm php7.4-mysql mariadb-client vim netcat \
    && mkdir -p /run/php

# Install wordpress needed to understand 
RUN wget https://wordpress.org/latest.tar.gz -P /var/www \
    && cd /var/www && tar -xzvf latest.tar.gz && rm latest.tar.gz

# change the owner of the wordpress directory to root in order to protect it from any non root user 
RUN chown -R www-data:www-data /var/www/wordpress \
    && chmod -R 755 /var/www/wordpress
# RUN chown -R root:root /var/www/wordpress

# Install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 
RUN chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

    
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/wp_config.sh /var/www/wordpress/wp_config.sh

WORKDIR /var/www/wordpress

EXPOSE  9000

ENTRYPOINT [ "/var/www/wordpress/wp_config.sh" ]
