#! /bin/bash

until mysqladmin ping -h"mariadb" -u"${MARIADB_USER}" -p"${MARIADB_PASSWORD}" --silent 2>/dev/null; do
	sleep 1;
	echo "waiting mariadb response..."
done

if [ ! -f "/var/www/html/wp-includes/version.php" ]; then
	wp core download --allow-root --path='/var/www/html'
	chown -R www-data:www-data /var/www/html
	chmod -R 755 /var/www/html
fi

if [ ! -f "/var/www/html/wp-config.php" ]; then 
	echo "creation of first step config wp cli.."
	wp config create --allow-root \
		--dbname=$MARIADB_DATABASE \
		--dbuser=$MARIADB_USER \
		--dbpass=$MARIADB_PASSWORD \
		--dbhost=mariadb:3306 \
		--path='/var/www/html'
fi

exec php-fpm8.2 -F
