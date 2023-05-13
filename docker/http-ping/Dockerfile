
#
# Build a fresh image.
#
FROM debian:buster

RUN apt update && apt install -y libidn2-0-dev daemontools-run procps python3 python3-pip

COPY requests.txt /requests.txt
RUN pip3 install -r /requests.txt

COPY run.IN /
COPY entrypoint.sh /entrypoint.sh

COPY http-request.py /


ENTRYPOINT ["/entrypoint.sh"]


