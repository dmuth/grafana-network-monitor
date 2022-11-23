#!/bin/bash
#
# This script imports our data source settings and dashboards.
# It is meant to be run within the tools container.
#

# Errors are fatal
set -e

if test ! "${API_KEY}"
then
    echo "! "
    echo "! The environment variable \$API_KEY is not set."
    echo "! Please pass the variable into the Docker container and run this script again."
    echo "! "
    exit 1
fi


/mnt/bin/manage-data-sources.py --api-key ${API_KEY}

cat /mnt/config/dashboards.json | /mnt/bin/manage-dashboards.py --import --api-key ${API_KEY}

