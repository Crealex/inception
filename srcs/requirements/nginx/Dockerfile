FROM debian:bookworm

RUN 	apt update && apt upgrade -y && \ 
		apt install -y nginx openssl vim 
RUN	mkdir -p /etc/nginx/ssl
RUN	openssl req -x509 -nodes -newkey rsa:2048 \
		-out /etc/nginx/ssl/myself.crt \
		-keyout /etc/nginx/ssl/myself.key \
		-subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=atomasi.42.fr/UID=atomasi"
RUN	chmod 775 /var/www/html && chown -R www-data:www-data /var/www/html
RUN	rm -f /etc/nginx/nginx.conf
COPY	./conf/nginx.conf /etc/nginx/nginx.conf

CMD	["nginx", "-g", "daemon off;"]
