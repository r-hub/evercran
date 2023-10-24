#! /bin/bash

set -e

cd /scripts
Rscript setup.R

crond -f
