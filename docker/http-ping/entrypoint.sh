#!/bin/bash
#
# Our entrypoint script.
#

# Errors are fatal
set -e

LOGDIR="/logs/http-ping"
SRC="/run.IN"

#
# If no urls were specified, set some sensible defaults.
#
if test ! "${URLS}"
then
    URLS="https://httpbin.dmuth.org/robots.txt https://httpbin.dmuth.org/delay/3,5,5"
fi

#
# Set up our /service directory and logs directory.
#
rm -fv /service
ln -s /etc/service /service

mkdir -p ${LOGDIR}

#
# Create a Daemontools service for a given host.
#
function createService() {

    ARG=$1

    #
    # This little bit of code came from https://stackoverflow.com/a/10586169/196073
    # and uses <<< which is a "here string" to split our arg on commas.
    #
    IFS_OLD=${IFS}
    IFS=', ' read -r -a ARGS <<< "$ARG"
    IFS=${IFS_OLD}

    URL=${ARGS[0]}
    INTERVAL=${ARGS[1]}
    TIMEOUT_CONNECT=${ARGS[2]}
    TIMEOUT_CONTENT=${ARGS[3]}

    if test ! "${INTERVAL}"
    then
        INTERVAL=10
    fi

    if test ! "${TIMEOUT_CONNECT}"
    then
        TIMEOUT_CONNECT=10
    fi

    if test ! "${TIMEOUT_CONTENT}"
    then
        TIMEOUT_CONTENT=10
    fi

    # Convert the URL into a valid directory name
    NAME=$(echo $URL | sed -e "s/[^a-z0-9]/_/g")

	LOG=${LOGDIR}/${NAME}.log

	cd /service

	mkdir -p ${NAME}
	cd ${NAME}

    #
    # Create our script which runs the http-request script.
    #
	cat ${SRC} | sed -e "s|%LOG%|${LOG}|g" -e "s|%URL%|${URL}|g" -e "s/%INTERVAL%/${INTERVAL}/" -e "s/%TIMEOUT_CONNECT%/${TIMEOUT_CONNECT}/" -e "s/%TIMEOUT_CONTENT%/${TIMEOUT_CONTENT}/" > run
	chmod 755 run

	echo "# Created service for querying ${URL}!"

} # End of service


#
# Create our services.
#
for URL in ${URLS}
do
	createService ${URL}
done

#ls -l /logs/http-ping # Debugging
#sleep 999999 # Debugging for when we want to connect to this script interactively
#exit # Debugging


#
# Launch our main service scanner, which will monitor all 
# services and restart them as necessary.
#
exec svscanboot 2>&1 >> ${LOGDIR}/svscanboot.log


