
FROM rhub/r-minimal:latest

RUN apk update
RUN apk add postgresql13-dev
RUN installr -d jsonlite RPostgres
RUN apk add postgresql13-client

COPY update-db.sh /etc/periodic/15min/
COPY update.sh /etc/periodic/daily/
COPY entrypoint.sh /root/

RUN echo "dbpassword" > /db-password

COPY scripts /scripts
