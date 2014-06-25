__author__ = 'Qimin'

from pymatgen.io.vaspio.vasp_output import Vasprun
from pymatgen.electronic_structure.plotter import BSPlotter

import os
import pickle

vasp_dir = os.path.dirname(os.path.abspath(__file__))
vasp_run = Vasprun(os.path.join(vasp_dir,"vasprun.xml"))

bs = vasp_run.get_band_structure(line_mode=True)

print bs.get_vbm()["energy"]
print bs.get_cbm()["energy"]
print bs.get_band_gap()["energy"]

# The above doesn't work on Vulcan or nano cluster due to a bug in virtualenv. Please use the following line to get band structure data from the cluster.

pickle.dump(bs, open("band_structure.dat", "w"))

# And then load the pickle object on your local machine.

#bs = pickle.load(open("band_structure.dat", "r"))

#print BSPlotter(bs).bs_plot_data(zero_to_efermi=True)
#BSPlotter(bs).save_plot(filename="1.pdf",img_format="pdf",ylim=None,zero_to_efermi=True,smooth=True)
