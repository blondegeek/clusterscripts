import numpy as np
import sys
import csv
import re

regex = re.compile("-?\d+.\d+")

fp = open(sys.argv[1])
lattice = []
scale = None
for i, line in enumerate(fp):
	if i == 1:
		scale = map(float,regex.findall(line))[0]
		print scale	
	elif i == 2 or i==3 or i==4:
	# a b c
		nums = regex.findall(line)
		lattice.append(map(float,nums))
	elif i > 4:
		break
fp.close()

a = scale*np.array(lattice[0])
b = scale*np.array(lattice[1])
c = scale*np.array(lattice[2])

astar = np.cross(b,c)/np.dot(np.cross(a,b),c)
bstar = np.cross(c,a)/np.dot(np.cross(a,b),c)
cstar = np.cross(a,b)/np.dot(np.cross(a,b),c)

starvolume = np.dot(np.cross(astar,bstar),cstar)

print "a: ", a
print "b: ", b
print "c: ", c

print "astar: ", astar
print "bstar: ", bstar
print "cstar: ", cstar

print "starvolume: ", starvolume
