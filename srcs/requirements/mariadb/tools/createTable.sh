#!/bin/bash

#setup dir for socket

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld


#start service
if [ ! -d "/var/lib/msyql/${MARIADB_DATABASE}" ]; then
	service mariadb start

	#waiting mariadb start
	until mysqladmin ping > /dev/null 2>&1; do
		echo "waiting starting mariadb..."
		sleep 1
	done

	#create table
	mysql -e "CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\`;"
	#create user
	mysql -e "CREATE USER IF NOT EXISTS \`$MARIADB_USER\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	#allowed rights for the table to the user
	mysql -e "GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO \`${MARIADB_USER}\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
	#change root user's password
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
	#update change
	mysql -e "FLUSH PRIVILEGES;"
	#shut down msyql
	mysqladmin -u root -p${MARIADB_ROOT_PASSWORD} shutdown
	#restart mysql
fi

exec mysqld --user=mysql
