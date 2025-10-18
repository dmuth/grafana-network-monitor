
#
# Build stage
#
# This will build our hacked version of ping, which will then be copied by the main container.
#
FROM debian:bookworm-slim as builder


RUN apt-get update && apt-get install -y git gcc make libcap-dev libidn2-0-dev nettle-dev 

#
# Compile my hacked version of ping from https://github.com/dmuth/iputils
# This will give us periodic updates on packets sent/received and include the
# name of the target in the output.
#
WORKDIR /
RUN git clone https://github.com/dmuth/iputils.git
WORKDIR /iputils
# Run this sed because I kept getting this error with a new verison of gcc:
# /usr/bin/ld: ping6_common.o:/iputils/ping6_common.c:99: multiple definition of device'; ping.o:/iputils/ping.c:106: first defined here
# 
RUN sed -i '1i CFLAGS += -fcommon' Makefile
RUN make

#
# Build a fresh image.
#
FROM debian:bookworm-slim 

RUN apt update && apt install -y libidn2-0-dev

WORKDIR /iputils

RUN apt install -y daemontools-run
RUN apt install -y procps

#
# Copy our hacked ping.
#
COPY --from=builder /iputils/ping /iputils/ping

COPY run.IN /
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
