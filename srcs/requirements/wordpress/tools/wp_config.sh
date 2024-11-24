#!/bin/bash

# sleep 15
echo "Waiting for database connection..."
until nc -z -v -w30 mariadb 3306
do
    echo "Waiting for database connection..."
    sleep 1
done

WP_CONF_FILE="/var/www/wordpress/wp-config.php"
WP_PATH="/var/www/wordpress"

if [ ! -f "$WP_CONF_FILE" ]; then
    wp config create --allow-root \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --path=/var/www/wordpress

fi

if ! wp core is-installed --allow-root ; then
    # WP is not installed. Let's try installing it.

    wp core install --allow-root \
        --url=https://aaoutem-.42.fr \
        --title="Inception" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" --skip-email 

    wp user create --allow-root \
        "$USER1" "$USER1_EMAIL" --role=author --user_pass="$USER1_PASSWORD"

    wp option update siteurl https://aaoutem-.42.fr --allow-root
    wp option update home https://aaoutem-.42.fr --allow-root

    wp rewrite flush --allow-root

fi

php-fpm7.4 -F
