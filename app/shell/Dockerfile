FROM rhub/r-minimal:latest

RUN apk update
RUN apk add postgresql13-dev
RUN installr -d jsonlite RPostgres
RUN apk add postgresql13-client

COPY app/shell/update-db.sh /etc/periodic/15min/
COPY app/shell/update.sh /etc/periodic/daily/
COPY app/shell/entrypoint.sh /root/

COPY app/shell/scripts /scripts

ENV R_DEFAULT_INTERNET_TIMEOUT=1800

ENTRYPOINT ["/root/entrypoint.sh"]
