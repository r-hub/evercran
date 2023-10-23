
FROM postgres:15.3-alpine3.18

RUN echo -n "dbpassword" > /db-password

COPY create.sql /docker-entrypoint-initdb.d/
