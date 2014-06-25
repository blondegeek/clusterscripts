import numpy as np
import sys
import csv
import re
import pickle

regex = re.compile("-?\d+.\d+")

fp = open(sys.argv[1])
lattice = []
ions = []
ionsxyz = []
scale = None
for i, line in enumerate(fp):
        if i == 1:
            scale = map(float,regex.findall(line))[0]
            print scale
        elif i == 2 or i==3 or i==4:
        # a b c
            nums = regex.findall(line)
            lattice.append(map(float,nums))
        elif i > 7:
            pos = regex.findall(line)
            ions.append(map(float,pos))
fp.close()

a = scale*np.array(lattice[0])
b = scale*np.array(lattice[1])
c = scale*np.array(lattice[2])

print a
print ions[2]

xions = []
yions = []
zions = []

for ion in np.array(ions):
    newvec = a*ion[0]+b*ion[1]+c*ion[2]
    ionsxyz.append(newvec)
    xions.append(newvec[0])
    yions.append(newvec[1])
    zions.append(newvec[2])
    
output = open('LIOstruct.pkl','wb')
pickle.dump( ionsxyz, output)
pickle.dump( xions, output)
pickle.dump( yions, output)
pickle.dump( zions, output)


