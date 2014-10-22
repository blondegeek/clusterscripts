'''
Created on September 22, 2013

@author: Tess
'''

import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder

s = pymatgen.read_structure('POSCAR')

structure =  SymmetryFinder(s).get_conventional_standard_structure()
pymatgen.write_structure(structure,"POSCAR")
