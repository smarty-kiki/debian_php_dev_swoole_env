FROM debian:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install nginx -y && \
    apt-get install mariadb-server -y && \
    apt-get install redis-server -y && \
    apt-get install mongodb -y && \
    apt-get install beanstalkd -y && \
    apt-get install php-fpm -y && \
    apt-get install php-redis -y && \
    apt-get install php-curl -y && \
    apt-get install php-mysql -y && \
    apt-get install php-mongodb -y && \
    apt-get install php-dom -y && \
    apt-get install php-mbstring -y && \
    apt-get install supervisor -y

COPY ./shell/start.sh /bin/start
RUN chown root:root /bin/start && \
    chmod +x /bin/start

RUN sed -i -e "s/^listen\ = .*/listen = \/var\/run\/php-fpm\.sock/g" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i -e "s/^bind\-address/#bind\-address/g" /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 80 3306

CMD start
