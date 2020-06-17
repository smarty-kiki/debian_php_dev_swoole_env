FROM debian:stretch

COPY ./config/apt_source.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install apt-utils -y && \
    apt-get upgrade -y && \
    apt-get install nginx -y && \
    apt-get install mariadb-server -y && \
    apt-get install redis-server -y && \
    apt-get install mongodb -y && \
    apt-get install beanstalkd -y && \
    apt-get install php7.4-cli -y && \
    apt-get install php7.4-dev -y && \
    apt-get install php7.4-xml -y && \
    apt-get install php7.4-zip -y && \
    apt-get install php7.4-curl -y && \
    apt-get install php7.4-mbstring -y && \
    apt-get install php7.4-mongodb -y && \
    apt-get install php7.4-mysql -y && \
    apt-get install php7.4-redis -y && \
    apt-get install php7.4-yaml -y && \
    apt-get install phpunit -y && \
    apt-get install inotify-tools -y && \
    apt-get install wget -y && \
    apt-get install gnupg -y && \
    apt-get install zip -y && \
    apt-get install git -y && \
    apt-get install composer -y && \
    apt-get install vim -y && \
    apt-get install tmux -y && \
    apt-get install tmuxinator -y && \
    apt-get install supervisor -y && \
    pecl install swoole

COPY ./shell/start.sh /bin/start
RUN chown root:root /bin/start && \
    chmod +x /bin/start

COPY ./config/bashrc /root/.bashrc
COPY ./config/tmux.conf /root/.tmux.conf

RUN mkdir -p /root/.tmuxinator
COPY ./config/tmuxinator_init.yml /root/.tmuxinator/init.yml
RUN sed -i -e "s/^bind\-address/#bind\-address/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^#general_log/general_log/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^query_cache_limit\ .*/query_cache_limit\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed -i -e "s/^query_cache_size\ .*/query_cache_size\ =\ 0M/g" /etc/mysql/mariadb.conf.d/50-server.cnf
RUN cat /etc/php/7.4/mods-available/pdo.ini | sed -e "s/pdo/swoole/g" > /etc/php/7.4/mods-available/swoole.ini
RUN ln -fs /etc/php/7.4/mods-available/swoole.ini /etc/php/7.4/cli/conf.d/10-swoole.ini

RUN touch /tmp/php_exception.log && \
    touch /tmp/php_notice.log && \
    touch /tmp/php_module.log && \
    chown www-data:www-data /tmp/php_exception.log && \
    chown www-data:www-data /tmp/php_notice.log && \
    chown www-data:www-data /tmp/php_module.log

ENV LC_ALL C.UTF-8

EXPOSE 80 3306

CMD start
