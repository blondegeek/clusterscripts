import numpy as np
import sys
import csv
import re
import pickle

regex = re.compile("-?\d+.\d+")

fp = open(sys.argv[1])
ions = []
scale = None
for i, line in enumerate(fp):
        if i >= 2 and i<=49:
            nums = regex.findall(line)
            ions.append(map(float,nums))
fp.close()

magforce = []

for ion in np.array(ions):
	#print len(ion)
	newvec = np.sqrt(ion[3]**2+ion[4]**2+ion[5]**2)
	magforce.append(newvec)

#print len(magforce)


print 'mean force Li:\t'+str(np.mean(magforce[0:16]))+'\t eV/A'
print 'mean force O:\t'+str(np.mean(magforce[16:39]))+'\t eV/A'
print 'mean force Ir:\t'+str(np.mean(magforce[39:48]))+'\t eV/A'

#for each in magforce[39:48]:
#	print each
