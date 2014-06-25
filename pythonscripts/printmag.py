import pymatgen 
from pymatgen.io.vaspio.vasp_output import Outcar
import os
import pickle

outcar = Outcar('OUTCAR2')

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

print " MAGMOM = 120*0 "+magstr
