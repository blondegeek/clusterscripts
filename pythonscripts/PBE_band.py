__author__ = 'Qimin'

from pymatgen.io.vaspio.vasp_output import Vasprun
from pymatgen.io.vaspio.vasp_input import VaspInput
from pymatgen.io.vaspio_set import MPNonSCFVaspInputSet
import os

vasp_dir = os.path.dirname(os.path.abspath(__file__))
vasp_run = Vasprun(os.path.join(vasp_dir, "vasprun.xml")).to_dict
nband = int(vasp_run['input']['parameters']['NBANDS'])
prec = str(vasp_run['input']['incar']['PREC'])
encut = int(vasp_run['input']['incar']['ENCUT'])

user_incar_settings={"PREC":prec,"ENCUT":encut,"EDIFF":1E-4,"NBANDS":nband,"NSW":0}
#user_incar_settings={"EDIFF":1E-4,"NBANDS":nband,"NSW":0}
mpvis = MPNonSCFVaspInputSet(user_incar_settings=user_incar_settings)
vi = VaspInput.from_directory(".")  # read the VaspInput from the previous run
mpvis.get_kpoints(vi['POSCAR'].structure).write_file('KPOINTS')
mpvis.get_incar(vi['POSCAR'].structure).write_file('INCAR')
