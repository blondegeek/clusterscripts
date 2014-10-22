import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder
import sys
s = pymatgen.read_structure('POSCAR')

prec=float(sys.argv[1])
#print SymmetryFinder(s).find_primitive()
structure =  SymmetryFinder(s,symprec=prec).get_refined_structure()
pymatgen.write_structure(structure,"POSCAR")

