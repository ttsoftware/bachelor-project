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

print '_'
print search_time
print '#'
print search_time
print '&'
if results:
    print len(results)/2
else:
    print 0

print '-'
if results:
    results = results.split("\n")[0:-1]
    for x in range(0, len(results), 2):
        print results[x+1] + ' - ' + results[x][8:-1].split(',')[0] + ':' + results[x][8:-1].split(',')[1]
