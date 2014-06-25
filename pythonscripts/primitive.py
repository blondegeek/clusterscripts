import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder

s = pymatgen.read_structure('POSCAR')

#print SymmetryFinder(s).find_primitive()
structure =  SymmetryFinder(s).find_primitive()
pymatgen.write_structure(structure,"POSCAR")

