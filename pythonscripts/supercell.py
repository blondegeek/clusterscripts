'''
Created on September 22, 2013

@author: Tess
'''

import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder
from pymatgen.core.structure_modifier import StructureModifier
from pymatgen.core.structure_modifier import SupercellMaker

s = pymatgen.read_structure('POSCAR')

s.make_supercell([3,1,1])


pymatgen.write_structure(s,"POSCAR2")

