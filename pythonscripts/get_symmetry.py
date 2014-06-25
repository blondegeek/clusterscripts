'''
Created on September 10, 2013

@author: Qimin
'''

import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder

s = pymatgen.read_structure('POSCAR')

print SymmetryFinder(s).get_spacegroup_number()
print SymmetryFinder(s).get_spacegroup_symbol()
print SymmetryFinder(s).get_symmetry_dataset()['wyckoffs']
#print SymmetryFinder(s).get_primitive_standard_structure()

