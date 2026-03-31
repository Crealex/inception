FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y wget php8.2-fpm php8.2-mysql mariadb-client

COPY		./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN		chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

COPY 		./tools/auto-config.sh /usr/local/bin/auto-config.sh

RUN		chmod +x /usr/local/bin/auto-config.sh

WORKDIR		/var/www/html

ENTRYPOINT	["/usr/local/bin/auto-config.sh"]
