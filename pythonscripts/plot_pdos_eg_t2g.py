__author__ = 'Qimin'

from pymatgen.io.vaspio.vasp_output import Vasprun
from pymatgen.io.vaspio_set import MPNonSCFVaspInputSet
from pymatgen.electronic_structure.plotter import DosPlotter
import pickle
import os
from collections import OrderedDict


vasp_dir = os.path.dirname(os.path.abspath(__file__))
vasp_run = Vasprun(os.path.join(vasp_dir, "vasprun.xml"))

dos = vasp_run.complete_dos

########### Total DOS

all_dos = OrderedDict()
all_dos["Total"] = dos

########### Site projected DOS

#all_dos = OrderedDict()
#structure = vasp_run.final_structure

#for i in xrange(len(structure)):
#    site = structure[i]
#    all_dos["Site " + str(i) + " " + site.specie.symbol] = dos.get_site_dos(site)

########### Element projected DOS

for el, dos in dos.get_element_dos().items():
    all_dos[el] = dos

########### Orbital projected DOS

#all_dos = {}
#all_dos = dos.get_spd_dos()

########### eg t2g

for i in xrange(len(structure)):
    site = structure[i]
    all_dos["Site " + str(i) + " " + site.specie.symbol] = dos.get_site_t2g_eg_resolved_dos(site)

pickle.dump(all_dos, open("pdos_xtalfield.dat", "w"))

#plotter = DosPlotter()
#plotter.add_dos_dict(all_dos)


#plotter.get_plot().show()
#plotter.get_plot([-3,3],[-5,5]).savefig(filename="spd_dos.pdf",img_format="pdf")
