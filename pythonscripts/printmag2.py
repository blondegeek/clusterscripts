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
# change this if loop to select only the magnetic species of interest
# this example was used for a 48 atom unit cell where atoms 41-48 were magnetic
	if i >= 40:
		strlist.append(str(magxlist[i])+" "+str(magylist[i])+" "+str(magzlist[i]))

magstr = " ".join(strlist)

magx2list = [(x)**2 for x in magxlist]
magy2list = [(x)**2 for x in magylist]
magz2list = [(x)**2 for x in magzlist]

magx3list = [np.absolute(x) for x in magxlist]
magy3list = [np.absolute(x) for x in magylist]
magz3list = [np.absolute(x) for x in magzlist]

magnorm = [np.sqrt(magx2list[i]+magy2list[i]+magz2list[i]) for i in range(0,len(magx2list))]

print "average mag moment on each ion"
print str(np.sqrt(sum(magnorm)/len(magnorm)))

print "quadrature"
print str(np.sqrt(sum(magx2list)/len(magx2list)))
print str(np.sqrt(sum(magy2list)/len(magy2list)))
print str(np.sqrt(sum(magz2list)/len(magz2list)))

print "mag average in each direction"
print str(sum(magx3list)/len(magx3list))
print str(sum(magy3list)/len(magy3list))
print str(sum(magz3list)/len(magz3list))

print "summed average"
print str(sum(magxlist)/len(magxlist))
print str(sum(magylist)/len(magylist))
print str(sum(magzlist)/len(magzlist))
print " MAGMOM = 120*0 "+magstr
