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

	echo "config created!"

	wp core install --allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="42 Inception atomasi" \
		--admin_user="${WP_ADMIN}" \
		--admin_password="${WP_PASSWORD_ADMIN}" \
		--admin_email="${WP_ADMIN_MAIL}" \
		--path='/var/www/html'

	echo "core installed!"

	wp user create --allow-root \
		"${WP_USER}" \
		"${WP_USER_MAIL}" \
		--user_pass="${WP_USER_PASSWORD}" \
		--role=author \
		--path='/var/www/html/'
	echo "user created!"
fi

exec php-fpm8.2 -F
