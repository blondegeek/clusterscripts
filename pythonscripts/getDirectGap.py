from pymatgen.io.vaspio.vasp_output import Outcar, Vasprun
from pymatgen.electronic_structure import bandstructure
import os

vasp_dir = os.path.dirname(os.path.abspath(__file__))
vasp_run = Vasprun(os.path.join(vasp_dir,"vasprun.xml"))

bs = vasp_run.get_band_structure(kpoints_filename=None, efermi=None,line_mode=False)
vbm = bs.get_vbm()['energy']
cbm = bs.get_cbm()['energy']
bandgap = bs.get_band_gap()['energy']
vbm_position = bs.get_vbm()['kpoint_index']
cbm_position = bs.get_cbm()['kpoint_index']
print vbm_position, cbm_position 
direct = False
if vbm_position == cbm_position:
	direct = True

print vbm, cbm, bandgap, direct
