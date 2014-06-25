import pymatgen 
from pymatgen.io.vaspio.vasp_output import Outcar
import os
import pickle
import numpy as np

outcar = Outcar('OUTCAR')

magarray = []

magx = outcar.magnetizationx
magy = outcar.magnetizationy
magz = outcar.magnetizationz

magxlist = [x["tot"] for x in magx]
magylist = [y["tot"] for y in magy]
magzlist = [z["tot"] for z in magz]

strlist = []

for i in range(0,len(magxlist)):
	if i >= 40:
		strlist.append(str(magxlist[i])+" "+str(magylist[i])+" "+str(magzlist[i]))

magstr = " ".join(strlist)

magx2list = [(x)**2 for x in magxlist]
magy2list = [(x)**2 for x in magylist]
magz2list = [(x)**2 for x in magzlist]

magx3list = [np.absolute(x) for x in magxlist]
magy3list = [np.absolute(x) for x in magylist]
magz3list = [np.absolute(x) for x in magzlist]

print "quadrature"
print str(np.sqrt(sum(magx2list)/len(magx2list)))
print str(np.sqrt(sum(magy2list)/len(magy2list)))
print str(np.sqrt(sum(magz2list)/len(magz2list)))


print "summed average"
print str(sum(magxlist)/len(magxlist))
print str(sum(magylist)/len(magylist))
print str(sum(magzlist)/len(magzlist))
print " MAGMOM = 120*0 "+magstr
