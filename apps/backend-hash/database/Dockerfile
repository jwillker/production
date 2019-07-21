FROM mysql:5.6

ENV MYSQL_ROOT_PASSWORD="secret"
ENV MYSQL_DATABASE="api"

COPY init.sql /docker-entrypoint-initdb.d/
