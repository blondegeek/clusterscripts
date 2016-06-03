__author__ = 'Tess'

from pymatgen.io.vasp import Vasprun
from pymatgen.electronic_structure.plotter import DosPlotter
import os
from collections import OrderedDict
from pymatgen.core.periodic_table import Element


vasp_dir = os.path.dirname(os.path.abspath(__file__))
vasp_run = Vasprun(os.path.join(vasp_dir, "vasprun.xml"))

dos = vasp_run.complete_dos

all_dos = OrderedDict()
all_dos["Total"] = dos


elem = dos.get_element_dos()

print elem.keys()

from copy import deepcopy

AgSe = elem[Element('Ag')].__add__(elem[Element('Se')])
CH = elem[Element('C')].__add__(elem[Element('H')])

all_dos.update({'Ag+Se':AgSe,'C+H':CH})

plotter = DosPlotter(sigma=0.05)
plotter.add_dos_dict(all_dos)

plotter.get_plot(xlim=[-3,4],ylim=[0,30],width=12,height=6).savefig(filename="orgo_inorg_dos.pdf",img_format="pdf")

