FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/createTable.sh /usr/local/bin/createTable.sh

RUN chmod +x /usr/local/bin/createTable.sh

ENTRYPOINT [ "/usr/local/bin/createTable.sh" ]
