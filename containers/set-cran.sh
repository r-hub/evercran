#! /bin/sh

CRAN="`grep ^${R_VERSION}[[:space:]] /tmp/cran.txt | grep -F ${R_VERSION} | cut -f2 | grep http`"

if [ -n "$CRAN" ]; then
    echo "options(CRAN = \"$CRAN\")" >> /root/.Rprofile
    echo "options(repos = c(CRAN = \"$CRAN\"))" >> /root/.Rprofile
    echo "options(download.file.method = \"wget\")" >> /root/.Rprofile
fi
