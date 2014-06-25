import pymatgen 
from pymatgen.io.vaspio.vasp_output import Outcar
import os
import pickle

outcar = Outcar('OUTCAR')

magarray = []

magx = outcar.magnetizationx
magy = outcar.magnetizationy
magz = outcar.magnetizationz

magxlist = [x["tot"] for x in magx]
magylist = [y["tot"] for y in magy]
magzlist = [z["tot"] for z in magz]

output = open('data.pkl','wb')
pickle.dump( magxlist, output)
pickle.dump( magylist, output)
pickle.dump( magzlist, output)
