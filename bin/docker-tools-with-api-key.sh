#!/bin/bash
#
# This script will spawn the tools container with an API key
#
# Its main use is for exporting or importing dashboards.
#

# Errors are fatal
set -e

# Change to the parent directory of the script
pushd $(dirname $0)/.. > /dev/null

if test ! "${API_KEY}"
then
    echo "! "
    echo "! You muse set the \$API_KEY environment variable to run this script."
    echo "! "
    echo "! Try: API_KEY=(YOUR_API_KEY) $0"
    echo "! "
    exit 1
fi

echo "# "
echo "# Connecting to the tools container..."
echo "# "
echo "# Here are the commands you're probably interested in:"
echo "# "
echo "# /mnt/bin/import.sh"
echo "# "
echo "# /mnt/bin/manage-dashboards.py --export --api-key \${API_KEY} > /mnt/config/dashboards.json"
echo "# "

docker-compose exec -e API_KEY=${API_KEY} tools bash


