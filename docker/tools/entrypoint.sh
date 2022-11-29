#!/bin/bash
#
# Our entrypoint script.
#

# Errors are fatal
set -e


#
# If we didn't get arguments, do default behavior.
#
if test ! "$1"
then

    while true
    do
        #
        # Prune our WAL of anything older than a day.  
        # We're ignoring errors because sometimes a file is newer than its enclosing directory.
        #
        echo "# Pruning old files..."
        /mnt/bin/prune-loki-wal.sh || true

        #
        # Why am I not sleeping for 3600 seconds like a normal person?
        # I chose this number because it is prime, which means that the script won't run
        # at the same time every single hour.
        #
        # I don't know about you, but I hate it when crontabs or similar all 
        # run at exactly the same time.  Spread the load out!
        #
        echo "# Sleeping for 3433 seconds..."
        sleep 3433
    done

    # This should never happen.
    exit

fi


#
# If we got arguments, run them.
#
exec $@

