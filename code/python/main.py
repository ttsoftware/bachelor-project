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

start = milli_time()
f = open(sys.argv[2], 'r')
text = f.read()
readfile_time = milli_time() - start
print 'DISK TIME: ' + str(readfile_time)

start = milli_time()

print reg[4:-6]

results = re.findall(reg[4:-6], text, re.IGNORECASE)[0]
    
search_time = milli_time() - start

print 'MATCH TIME: ' + str(search_time)

print 'TOTAL TIME: ' + str(readfile_time + search_time)

if results:
    counter = 0
    for result in results:
        if len(result) > 0:
            counter += 1
    print 'NUMBER OF MATCHES: ' + str(counter)
else:
    print 'NUMBER OF MATCHES: ' + str(0)

#print 'MATCHES:'
#if results:
#    for result in results:
#        if len(result) > 0:
#            print result
