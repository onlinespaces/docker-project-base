FROM mysql:5.7
MAINTAINER Scott Collier <scott@onlinespaces.com>

RUN { \
      echo "[mysqld]"; \
      echo "character-set-server=${CHAR_SET_SERVER}"; \
      echo "collation-server=${COLLATION_SERVER}"; \
      echo "[client]"; \
      echo "default-character-set=${DEFAULT_CHAR_SET}"; \
} >> /etc/mysql/mysql.conf.d/zz-mysqld.cnf
