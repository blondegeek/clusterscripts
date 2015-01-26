from pymatgen.io.vaspio.vasp_output import Vasprun
from pymatgen.electronic_structure.plotter import BSPlotter
from matplotlib import pyplot as plt
from scipy.interpolate import interp1d

import os
import pickle

bs = pickle.load(open("band_structure_2.dat", "r"))
#bs.efermi

fig, ax = plt.subplots()
xCoord = range(len(bs.kpoints))

print len(xCoord)
print len(bs.bands[1][220])
for band in bs.bands[1][220:240]:
    f = interp1d(xCoord, band, kind='cubic')    
    ax.plot(xCoord,band)
plt.show()
