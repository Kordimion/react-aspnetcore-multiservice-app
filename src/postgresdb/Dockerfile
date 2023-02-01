FROM postgres:14.4-alpine
ADD ./dbsetup /dbsetup
COPY init_api.sql ./dbsetup/init_api.sql
COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh