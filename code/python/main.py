import regex as re
import sys

if len(sys.argv) < 3:
    print "Not enough arguments"
    exit()

f = open(sys.argv[1], 'r')
reg = f.readline()
f.close()

f = open(sys.argv[2], 'r')
text = f.read()
f.close()

result = re.search(reg, text)

print result