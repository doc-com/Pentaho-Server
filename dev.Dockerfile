FROM postgres:latest

COPY postgresql-db-scripts /docker-entrypoint-initdb.d/