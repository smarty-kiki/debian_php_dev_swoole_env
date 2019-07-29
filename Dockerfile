FROM debian:latest

RUN apt-get update && \
    apt-get install apt-utils -y && \
    apt-get upgrade -y && \
    apt-get install nginx -y && \
    apt-get install mariadb-server -y && \
    apt-get install redis-server -y && \
    apt-get install beanstalkd -y && \
    apt-get install php-curl -y && \
    apt-get install php-dom -y && \
    apt-get install php-mbstring -y && \
    apt-get install php-yaml -y && \
    apt-get install php-dev -y && \
    apt-get install inotify-tools -y && \
    apt-get install supervisor -y && \
    pecl install swoole

COPY ./shell/start.sh /bin/start
RUN chown root:root /bin/start && \
    chmod +x /bin/start

RUN sed -i -e "s/^bind\-address/#bind\-address/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^#general_log/general_log/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^query_cache_limit\ .*/query_cache_limit\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^query_cache_size\ .*/query_cache_size\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN cat /etc/php/7.3/mods-available/pdo.ini | sed -e "s/pdo/swoole/g" > /etc/php/7.3/mods-available/swoole.ini
RUN ln -fs /etc/php/7.3/mods-available/swoole.ini /etc/php/7.3/cli/conf.d/10-swoole.ini

RUN touch /tmp/php_exception.log && \
    touch /tmp/php_notice.log && \
    chown www-data:www-data /tmp/php_exception.log && \
    chown www-data:www-data /tmp/php_notice.log

EXPOSE 80 3306

CMD start
