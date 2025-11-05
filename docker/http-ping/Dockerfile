
#
# Build a fresh image.
#
FROM debian:bookworm-slim as builder

RUN apt update && apt install -y libidn2-0-dev daemontools-run procps python3 python3-pip python3.11-venv

# Create our virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requests.txt /requests.txt
RUN pip install --no-cache-dir -r /requests.txt

COPY run.IN /
COPY entrypoint.sh /entrypoint.sh

COPY http-request.py /

ENTRYPOINT ["/entrypoint.sh"]
