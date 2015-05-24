#!/usr/bin/env python

import re
import sys
import time

milli_time = lambda: int(round(time.time() * 1000))

if len(sys.argv) < 3:
    print "Not enough arguments"
    exit()

f = open(sys.argv[1], 'r')
reg = f.readline()
f.close()

start = milli_time()
f = open(sys.argv[2], 'r')
text = f.read()
readfile_time = milli_time() - start
print readfile_time

f.close()

start = milli_time()
try:
    results = re.findall(reg[4:-5], text, re.IGNORECASE)[0]
except:
    exit()
search_time = milli_time() - start

print '-'
if results:
    for result in results:
        if len(result) > 0:
            print result

print '_'
print search_time

print '#'
print readfile_time + search_time

print '&'
if results:
    print len(result)
else:
    print 0
