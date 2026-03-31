#! /bin/bash

until mysqladmin ping -h"mariadb" -u"${MARIADB_USER}" -p"${MARIADB_PASSWORD}" --silent 2>/dev/null; do
	sleep 1;
	echo "waiting mariadb response..."
done

if [! -f "/var/www/html/wp-config.php"; then 
	wp config create --allow-root \
		--dbname=$MARIADB_DATABSE \
		--dbuser=$MARIADB_USER \
		--dpass=$MARIADB_PASSWORD \
		--dbhost=mariadb:3306 \
		--path='/var/www/wordpress'
