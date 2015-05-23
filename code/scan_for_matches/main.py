#!/usr/bin/env python
from __future__ import division
import re
import sys
import time
import subprocess

milli_time = lambda: int(round(time.time() * 1000))

if len(sys.argv) < 3:
    print "Not enough arguments"
    exit()

start = milli_time()
results = subprocess.check_output("scan_for_matches " + sys.argv[1] + ' < ' + sys.argv[2], shell=True)
search_time = milli_time() - start

print '-'
if results:
    results = results.split("\n")[0:-1]
    for result in results:
        print result
print '-'
print '_'
print search_time
print search_time
if results:
    print len(results)/2
else:
    print 0
