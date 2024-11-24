#!/bin/bash

sleep 5

echo "Waiting for database connection..."
until nc -z -v -w30 mariadb 3306 2>/dev/null
do
    echo "Waiting for database connection..."
    sleep 1
done

chmod -R 755 /var/www/wordpress
chown -R www-data:www-data /var/www/wordpress

WP_CONF_FILE="/var/www/wordpress/wp-config.php"

wp core download --allow-root

if [ ! -f "$WP_CONF_FILE" ]; then
    wp config create --allow-root \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --path=/var/www/wordpress

fi

if ! wp core is-installed --allow-root ; then

    wp core install --allow-root \
        --url="${DOMAINE_NAME}" \
        --title="Inception" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASSWORD" \
        --admin_email="$ADMIN_EMAIL" --skip-email 

    wp user create --allow-root \
        "$USER1" "$USER1_EMAIL" --role=author --user_pass="$USER1_PASSWORD"

    wp option update siteurl ${DOMAINE_NAME} --allow-root
    wp option update home ${DOMAINE_NAME} --allow-root

    wp rewrite flush --allow-root

fi

php-fpm7.4 -F
