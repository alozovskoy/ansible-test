#!/bin/bash

mysqlRootPass="$1"
zabbixPass="$2"
zabbixHost="$3"

mysql -u root -p$mysqlRootPass <<-EOF
CREATE DATABASE IF NOT EXISTS zabbixdb character set utf8 collate utf8_bin;
GRANT ALL PRIVILEGES ON zabbixdb.* TO zabbix@localhost IDENTIFIED BY '$zabbixPass';
GRANT ALL PRIVILEGES ON zabbixdb.* TO zabbix@'$zabbixHost' IDENTIFIED BY '$zabbixPass';
FLUSH PRIVILEGES;
EOF
