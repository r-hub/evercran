# -*- Dockerfile -*-

FROM debian/eol:sarge

ENV PAGER=less
ENV LESS=-r

RUN echo 'deb http://ppa.r-pkg.org/evercran sarge main' \
    >> /etc/apt/sources.list

COPY sarge-versions.txt .

RUN cat sarge-versions.txt | sed '/1\.0\.0/,/1\.9\.1/!d;/1\.9\.1/q' > \
    1x-versions.txt

RUN apt-get update && \
    apt-get install -y `cat 1x-versions.txt | sed 's/^/r-/'` && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/lib/apt/lists/partial && \
    rm sarge-versions.txt

WORKDIR /root

CMD [ "bash" ]
