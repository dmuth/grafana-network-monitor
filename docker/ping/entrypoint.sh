#!/bin/bash
#
# Our entrypoint script.
#

# Errors are fatal
set -e

LOGDIR="/logs/ping"
SRC="/run.IN"

#
# If no hosts were specified, set some sensible defaults.
#
if test ! "${HOSTS}"
then
	HOSTS="google.com 8.8.8.8 1.1.1.1"
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

	NAME=$1
	LOG=${LOGDIR}/${NAME}.log

	cd /service

	mkdir -p ${NAME}
	cd ${NAME}

	#
	# Create our script which pings the specified host for 1 hour, 
	# prepends human-readable timestamps, and writes that all to 
	# a logfile for just this host.
	#
	# Note this is my hacked version of ping, so it will write a
	# checkpoint out every 10 pings.
	#
	NUM_PINGS=3600
	#NUM_PINGS=5 # Debugging

	cat ${SRC} | sed -e "s|%LOG%|${LOG}|g" -e "s/%NAME%/${NAME}/" -e "s/%NUM_PINGS%/${NUM_PINGS}/" > run
	chmod 755 run

	echo "# Created service for pinging ${NAME}!"

} # End of service


#
# Create our services.
#
for HOST in ${HOSTS}
do
	createService ${HOST}
done

#cat /service/8.8.8.8/run # Debugging
#/service/8.8.8.8/run # Debugging
#ls -l /logs/ping/ # Debuggin
#exit # Debugging

#
# Launch our main service scanner, which will monitor all 
# services and restart them as necessary.
#
exec svscanboot 2>&1 >> ${LOGDIR}/svscanboot.log


