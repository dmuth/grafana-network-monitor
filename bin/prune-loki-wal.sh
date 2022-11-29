#!/bin/bash
#
# Remove old files from the WAL
#

# Errors are fatal
set -e

if test ! "${DOCKER}"
then
    echo "! "
    echo "! This must be run from within the tools Docker container."
    echo "! "
    exit 1
fi

cd /data/wal

find . -depth -mindepth 1 -mtime +1 -delete -print

