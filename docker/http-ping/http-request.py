#!/usr/bin/env python3
#
# This script runs a request against a specific HTTP endpoint
# and then reports back on the time, status code, and timeout status
#

import argparse
import time

import requests
import urllib3.exceptions

parser = argparse.ArgumentParser(
    prog='http-request',
    description='Periodically runs an HTTP report and prints back status and time taken.')

parser.add_argument("url", help = "The URL to query.")
parser.add_argument("interval", type = float, help = "How many seconds to wait between requests?")
parser.add_argument("timeout_connect", type = float, metavar = "connect_timeout", 
    help = "Seconds before a connect timeout is reached.")
parser.add_argument("timeout_content", type = float, metavar = "content_timeout", 
    help = "Seconds before a content timeout is reached.")

args = parser.parse_args()


#
# Make our request and return the results
#
def request(url, timeout_connect, timeout_content):

    retval = {
        "url": args.url,
        "status": "",
        "time": "",
        "size": "0",
        "error": ""
        }

    try:
        #
        # The reason we're not using r.elapsed.total_seconds() for the request timing
        # is because it doesn't work when a request fails.
        #
        time_start = time.time()
        r = requests.get(url, timeout = (timeout_connect, timeout_content), 
            allow_redirects = False)
        time_elapsed = time.time() - time_start
        retval["time"] = int(time_elapsed * 1000)
        retval["size"] = len(r.content)

    except requests.exceptions.ConnectionError as e:

        time_elapsed = time.time() - time_start
        retval["time"] = int(time_elapsed * 1000)

        if "Connection refused" in repr(e.args[0].reason):
            # http://localhost:12345/
            retval["error"] = "connection_refused"

        elif "failure in name resolution" in repr(e.args[0].reason):
            # http://localhost.invalid/
            retval["error"] = "dns_lookup_failed"

        elif "connect timeout=" in repr(e.args[0].reason):
            # http://10.255.255.254
            retval["error"] = "timeout_connect"

        elif "Network is unreachable" in repr(e.args[0].reason):
            # http://10.255.255.255
            retval["error"] = "network_is_unreachable"

        else:
            retval["error"] = f"\"Other: {e.args[0].reason}\""

    except requests.exceptions.ReadTimeout as e:

        time_elapsed = time.time() - time_start
        retval["time"] = int(time_elapsed * 1000)

        if "Read timed out" in repr(e.args[0]):
            # http://httpbin.dmuth.org/delay/10
            retval["error"] = "timeout_content"

    else:
        retval["status"] = r.status_code

    return(retval)


#
# Our main entrypoint
#
def main(args):

    #print("ARGS", args) # Debugging

    while True:
        data = request(args.url, args.timeout_connect, args.timeout_content)
        print(f"url=\"{data['url']}\" status=\"{data['status']}\" time=\"{data['time']}\" size=\"{data['size']}\" error=\"{data['error']}\"", flush = True)
        time.sleep(args.interval)

main(args)


