#!/usr/bin/env python3
import os
import sys
import logging
import tempfile
import subprocess
import json

logging.basicConfig(level=logging.DEBUG, filename = os.path.join(tempfile.gettempdir(), "make_cdb.log"))

try:
    # Prepare command to be executed
    logging.info("Called with arguments: " + ' '.join(sys.argv))
    make_command = ["make", "-q", "compile_db"]
    # Call make
    logging.info("Invoking '{}'".format(' '.join(make_command)))
    output = subprocess.Popen(make_command, stdout=subprocess.PIPE).communicate()[0]
    if output:
        output = output.decode('utf8')
    # Parse response
    logging.info("Parsing json response")
    db = json.loads(output)
    # Spit result
    logging.info("Dumping result")
    json.dump(db, sys.stdout)
except Exception as e:
    # Log any kind of exception
    logging.error("Exception occurred", exc_info=True)
