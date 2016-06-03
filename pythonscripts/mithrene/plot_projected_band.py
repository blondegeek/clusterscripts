from pymatgen.io.vasp.outputs import BSVasprun
from pymatgen.electronic_structure.plotter import BSPlotterProjected

import os
import pickle

vasp_dir = os.path.dirname(os.path.abspath(__file__))
vasp_run = BSVasprun(os.path.join(vasp_dir,"vasprun.xml"),parse_projected_eigen=True)

bs = vasp_run.get_band_structure(line_mode=True)

bsp = BSPlotterProjected(bs)

p = bsp.get_color_grouped([{'elements':['Ag','Se'],'color':[255,140,0]},
                           {'elements':['C','H'],'color':[0,0,0]}],ylim=[-3,4])
p.savefig('color_band.pdf')

#pickle.dump(bs, open("band_structure.dat", "w"))
