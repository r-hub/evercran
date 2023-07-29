
FROM rhub/r-minimal:latest

RUN apk update
RUN apk add postgresql13-dev
RUN installr -d jsonlite RPostgres
RUN apk add postgresql13-client
