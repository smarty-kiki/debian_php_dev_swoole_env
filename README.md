# debian_php_dev_swoole_env
基于 Debian 的 PHP 开发环境容器，现被使用于 frame 框架的开发环境

### 环节说明
这个开发环境中含有以下组件
 * mariadb-server
 * php-cli
 * php-swoole
 * php-curl
 * php-mysql
 * php-dom
 * php-mbstring
 * php-yaml
 * supervisor

### 使用方法：

sudo docker run --rm -ti -p 80:80 -p 3306:3306 --name debian_php_dev_swoole_env \
      -v {CODE_PATH}:/var/www/{PROJECT_NAME} \
      -v {SUPERVISOR_CONFIG_FILE}:/etc/supervisor/conf.d/{CONFIG_NAME}.conf \
      kikiyao/debian_php_dev_swoole_env start

示例：

https://github.com/smarty-kiki/api_frame/blob/master/project/tool/start_dev_server.sh
