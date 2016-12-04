FROM mysql:5.7
MAINTAINER Scott Collier <scott@onlinespaces.com>

ARG CHAR_SET_SERVER
ARG COLLATION_SERVER
ARG DEFAULT_CHAR_SET

RUN { \
      echo "innodb_data_file_path = ibdata1:10M:autoextend"; \
      echo "[mysqld]"; \
      echo "character-set-server=${CHAR_SET_SERVER}"; \
      echo "collation-server=${COLLATION_SERVER}"; \
      echo "[client]"; \
      echo "default-character-set=${DEFAULT_CHAR_SET}"; \
    } >> /etc/mysql/conf.d/mysql.cnf