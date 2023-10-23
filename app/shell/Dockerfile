
FROM rhub/r-minimal:latest

RUN apk update
RUN apk add postgresql13-dev
RUN installr -d jsonlite RPostgres
RUN apk add postgresql13-client

COPY update-db.sh /etc/periodic/15min/update-db.sh
COPY update.sh /etc/periodic/daily/update.sh
COPY entrypoint.sh /root/entrypoint.sh

COPY scripts /scripts
