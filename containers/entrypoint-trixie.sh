#!/bin/bash

# This entry point does not do anything, but we include it, so
# you can call entrypoint.sh for every evercran container.

exec ${1+"$@"}
