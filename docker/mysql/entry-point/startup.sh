#!/usr/bin/env bash

echo "[mysqld]" >> /etc/mysql/conf.d/mysql.cnf
echo "character-set-server=utf8mb4" >> /etc/mysql/conf.d/mysql.cnf
echo "collation-server=utf8mb4_unicode_ci" >> /etc/mysql/conf.d/mysql.cnf
echo "[client]" >> /etc/mysql/conf.d/mysql.cnf
echo "default-character-set=utf8mb4" >> /etc/mysql/conf.d/mysql.cnf