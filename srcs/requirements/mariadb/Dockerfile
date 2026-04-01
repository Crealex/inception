FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y mariadb-server && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && chmod 777 /var/run/mysqld
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/createTable.sh /usr/local/bin/createTable.sh

RUN chmod +x /usr/local/bin/createTable.sh

ENTRYPOINT [ "/usr/local/bin/createTable.sh" ]
