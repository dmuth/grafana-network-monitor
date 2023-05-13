#!/bin/bash
#
# This script will kill a Docker container (if running), build it, and start it up.
#
# It's main use is for building out a container.
#

# Errors are fatal
set -e

# Change to the parent directory of the script
pushd $(dirname $0)/.. > /dev/null

if test ! "$1"
then
    echo "! "
    echo "! Syntax: $0 IMAGE_NAME"
    echo "! "
    exit 1
fi

IMAGE=$1

docker-compose kill ${IMAGE} || true

docker-compose build ${IMAGE} 
docker-compose up -d ${IMAGE}


