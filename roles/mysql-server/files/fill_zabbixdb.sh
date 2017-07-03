#!/bin/bash

zabbixPass="$1"
timestamp="$2"

mysql -u zabbix -p$zabbixPass zabbixdb < /tmp/$timestamp/schema.sql
mysql -u zabbix -p$zabbixPass zabbixdb < /tmp/$timestamp/images.sql
mysql -u zabbix -p$zabbixPass zabbixdb < /tmp/$timestamp/data.sql
