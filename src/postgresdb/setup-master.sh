#!/bin/bash
echo 'SETUP DATABASE'

echo $PGDATA

# Public IP access 
echo "host all all 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"

#cp /dbsetup/master_postgresql.conf $PGDATA/postgresql.conf

set -e

echo "CREATE DB "$DB_NAME_API
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "CREATE DATABASE $DB_NAME_API;"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d $DB_NAME_API < ./dbsetup/init_api.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -l

#Check user
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -c "SELECT * FROM pg_user;"

echo "finished" > /tmp/finished.ok
ls /tmp

if (test -f /tmp/finished.ok); then echo "yes"; else echo "no"; fi