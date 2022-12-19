#!/bin/bash
#
# Kill, remove, and start our ping container.
# This script should be run when there are changes to hosts
# that are being monitored.
#

# Errors are fatal
set -e

# Change to the parent directory of this script
pushd $(dirname $0)/.. > /dev/null

docker-compose kill ping
docker-compose rm -f ping
docker-compose up -d

