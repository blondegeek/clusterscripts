import numpy as np
import sys
import csv
import re

regex = re.compile("-?\d+.\d+")

fp = open(sys.argv[1])
lattice = []
atompos = []
scale = None
for i, line in enumerate(fp):
        if i == 1:
                scale = map(float,regex.findall(line))[0]
        elif i == 2 or i==3 or i==4:
        # a b c
                nums = regex.findall(line)
                lattice.append(map(float,nums))
        elif i > 7:
                nums = regex.findall(line)
                atompos.append(map(float,nums))
fp.close()

a = scale*np.array(lattice[0])
b = scale*np.array(lattice[1])
c = scale*np.array(lattice[2])

atoms=[]
for atom in atompos:
        atoms.append(np.array(atom))

cart=[]
for atom in atoms:
        newpos = atom[0]*a+atom[1]*b+atom[2]*c
        cart.append(newpos)
