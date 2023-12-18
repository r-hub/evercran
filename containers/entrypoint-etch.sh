#!/bin/bash

# This is for https://github.com/r-hub/evercran/issues/3
# We need linux32 for an x86_64 host where `arch` returns `x86_64`, but
# we cannot use it on an arm64 host, because it fails currently.

if [ "`arch`" = "x86_64" ]; then
    exec linux32 ${1+"$@"}
else
    exec ${1+"$@"}
fi
