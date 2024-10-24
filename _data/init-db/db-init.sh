#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE keycloak;
    CREATE DATABASE ige;
	CREATE DATABASE ingrid_portal;
    CREATE DATABASE mdek;
EOSQL


