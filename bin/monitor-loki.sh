#!/bin/bash
#
# This script watches storage usage of the Loki database
#

# Fail with error status if a command fails.
set -e

# Change to the parent directory of this script
pushd $(dirname $0)/.. > /dev/null

DIR="data"
DIR_DATA="${DIR}/loki-data"
DIR_WAL="${DIR}/loki-wal"


echo "Num chunks: $(ls -l ${DIR_DATA}/chunks | wc -l)"
echo
ls -ltrh ${DIR_DATA}/chunks | tail 
ls -ltrh ${DIR_WAL} | tail



