'''
Created on September 10, 2013

@author: Qimin
'''
import sys
import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder

file = str(sys.argv[1])

s = pymatgen.read_structure(file)

prec = float(sys.argv[2])

print SymmetryFinder(s,symprec=prec).get_spacegroup_number()
print SymmetryFinder(s,symprec=prec).get_spacegroup_symbol()
print SymmetryFinder(s,symprec=prec).get_symmetry_dataset()['wyckoffs']
#print SymmetryFinder(s).get_primitive_standard_structure()

wyckoff = open("POSCAR_symm_wyckoff","w")

wyckoff.write(str(SymmetryFinder(s,symprec=prec).get_spacegroup_number())+'\n')
wyckoff.write(SymmetryFinder(s,symprec=prec).get_spacegroup_symbol()+'\n')
wyckoff.write(str(SymmetryFinder(s,symprec=prec).get_symmetry_dataset()['wyckoffs']))
wyckoff.close()
