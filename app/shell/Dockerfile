
FROM rhub/r-minimal:latest

RUN apk update
RUN apk add postgresql13-dev
RUN installr -d jsonlite RPostgres
RUN apk add postgresql13-client

RUN COPY update-db.sh /etc/periodic/15min/update-db.sh
RUN COPY update.sh /etc/periodic/daily/update.sh
RUN COPY entrypoint.sh /root/entrypoint.sh
