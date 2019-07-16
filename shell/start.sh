#!/bin/bash

if  [ -n "$TIMEZONE" ]
then
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE >/etc/timezone
fi

service mysql start
service supervisor start

mysql -e "create database \`default\`"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password'"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'password'"

date > /tmp/php_exception.log
date > /tmp/php_notice.log

if [ -f "$AFTER_START_SHELL" ]
then
    /bin/bash $AFTER_START_SHELL
fi

tail -n 100 -F /var/log/mysql/error.log /var/log/redis/redis-server.log  /tmp/php_exception.log /tmp/php_notice.log /var/log/mysql/mysql.log
