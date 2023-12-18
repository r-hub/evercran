# -*- Dockerfile -*-

FROM debian/eol:sarge

ENV PAGER=less
ENV LESS=-r

RUN echo 'deb http://ppa.r-pkg.org/evercran sarge main' \
    >> /etc/apt/sources.list

COPY versions-sarge.txt .

RUN cat versions-sarge.txt | sed '/1\.0\.0/,/1\.9\.1/!d;/1\.9\.1/q' > \
    versions-1x.txt

RUN apt-get update && \
    apt-get install -y linux32 `cat versions-1x.txt | sed 's/^/r-/'` && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/lib/apt/lists/partial && \
    rm versions-sarge.txt versions-1x.txt

WORKDIR /root

COPY entrypoint-sarge.sh /usr/local/bin/entrypoint.sh
COPY inode64.so /usr/local/lib/inode64.so
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "bash" ]
