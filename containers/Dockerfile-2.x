# -*- Dockerfile -*-

FROM debian/eol:wheezy

ENV PAGER=less
ENV LESS=-r

COPY 2.x-versions.txt .

RUN apt-get update && \
    apt-get install -y linux32 wget ca-certificates && \
    for ver in `cat 2.x-versions.txt`; do \
      wget https://github.com/r-hub/R/releases/download/v${ver}/r-evercran-debian-7.11-${ver}_1-1_i386.deb && \
      dpkg -i r-evercran-debian-7.11-${ver}_1-1_i386.deb || true && \
      apt-get -fy install; \
    done && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/lib/apt/lists/partial && \
    rm 2.x-versions.txt

WORKDIR /root

COPY wheezy-entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "bash" ]
