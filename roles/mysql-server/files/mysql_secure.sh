#!/bin/bash

rootPass="$1"
adminPass="$2"

mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('$rootPass') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' IDENTIFIED BY '$adminPass' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
