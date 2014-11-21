'''
Created on September 22, 2013

@author: Tess

This script is to help quickly assess basic information about symmetrized lithium 
iridate structures. Note that if you give a relaxed structure from a calculation with
ISYM=0 your CONTCAR may not have the same symmetry as your POSCAR did. See getsymwyck.py, refined.py, 
conv.py, and primitive.py scripts to symmetrize your CONTCAR file such that you can
compare it to multiple runs.

This script prints out the:
formula
spacegroup
lattice vector magnitudes a b c
lattice vector angles
number of sites
-----
wyckoff positions
-----
distinct Ir-Ir bonds
-----
distinct Ir-O-Ir angles

'''

import numpy as np
import math
import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder

s = pymatgen.read_structure('POSCAR2')

# GET BASIC STRUCTURAL INFO

# composition
print "Formula:\t"+str(s.composition.formula)
# spacegroup
print "Spacegroup:\t"+str(SymmetryFinder(s).get_spacegroup())
# lattice constant lengths
print "---------"
print "a\tb\tc"
print "\t".join(str(round(each,2)) for each in s.lattice.abc)
# and angles
print "alpha\tbeta\tgamma"
print "\t".join(str(round(each,2)) for each in s.lattice.angles)
print "---------"
# total number of sites
print "Num. of Sites: "+str(s.num_sites)
print "---------"

# print symmetrically distinct atoms and their wyckoff positions
print "Wyckoff Postions"
equiv=SymmetryFinder(s).get_symmetry_dataset()["equivalent_atoms"]
wy=SymmetryFinder(s).get_symmetry_dataset()["wyckoffs"]

# GROUP ATOMS BY EQUIVALENT POSITIONS
#
# this is redundant for primitive cells made by pymatgen
# but for conventional unit cells equivalent positions are spread out
# this is why we always loop through the list "atoms"
# versus just looping through s.num_sites

atoms=range(0,s.num_sites)
atoms=[x for (y,x) in sorted(zip(equiv,atoms))]

# CREATE LIST OF SPECIES IN THE ORDER THAT PRESERVES ADJACENT ATOMS
# WITH EQUIVALENT POSITIONS
#
iridiums=[i for i in atoms if str(s[i].specie)=="Ir"]
lithiums=[i for i in atoms if str(s[i].specie)=="Li"]
oxygens=[i for i in atoms if str(s[i].specie)=="O"]

# CREATE LIST OF ATOMNUMBERS (ELEMENT + NUMBER) TO IDENTIFY DISTINCT WYCKOFF POSITION

atomNumber=range(0,s.num_sites) #THIS IS JUST TO INITIALIZE
speciesCounter="None"
equivCounter=0
enumCounter=0
for i in atoms:
	if str(s[i].specie)==speciesCounter:
		if equiv[i]!=equivCounter:
			enumCounter+=1
			equivCounter=equiv[i]
	elif str(s[i].specie)!=speciesCounter:
		speciesCounter=str(s[i].specie)
		enumCounter=1
		equivCounter=equiv[i]
	atomNumber[i]=str(s[i].specie)+str(enumCounter)

#PRINT UNIQUE WYCKOFF POSITIONS WITH ATOMNUMBER LABEL

counter = -1
unique=list()
for i in atoms:
	if int(counter)!=int(equiv[i]):
		unique.append((atomNumber[i],s[i].frac_coords,wy[i]))
		counter=int(equiv[i])
#print unique
for each in unique:
	print "\t".join(str(e) for e in each)	

print "---------"

# print distinct Ir-Ir bonds
print "Distinct Ir-Ir Bond Lengths"


#Ir bonds are usually 3.0+/-0.3 AA away (for lithium and sodium iridate)

equivcounter=-1
distances=list()
for i in iridiums:
	if equivcounter!=equiv[i]:
		equivcounter=equiv[i]
		neigh = s.get_neighbors_in_shell(s[i].coords,3.0,0.3)
		for each in neigh:
			if each[2] in iridiums:
				distances.append([sorted([atomNumber[i],atomNumber[each[2]]]),round(each[1],5)])
distinctDistances=list()
map(lambda x: not x in distinctDistances and distinctDistances.append(x), distances)

prettyDistinctDistances = [ ["-".join(str(e) for e in each[0]),str(each[1])] for each in distinctDistances]
for each in prettyDistinctDistances:
        print "\t".join(each)

print "---------"


# get distinct Ir-O-Ir angles


print "Distinct Ir-O-Ir Bond Angles"

counter=[0,0,0]
for i in oxygens[0::1]:
	thisONeigh=s.get_neighbors_in_shell(s[i].coords,2.1,0.3)
	IrList=[site[2] for site in thisONeigh if site[2] in iridiums]
	IrListCoord=[site[0] for site in thisONeigh if site[2] in iridiums]
	threeEquiv = [atomNumber[IrList[0]],atomNumber[i],atomNumber[IrList[1]]]
	if counter!=sorted(threeEquiv):
		counter=sorted(threeEquiv)
		A=s[i].coords-IrListCoord[0].coords
		B=s[i].coords-IrListCoord[1].coords
		angle=str(round(np.degrees(math.acos(np.dot(A,B)/(np.linalg.norm(A)*np.linalg.norm(B)))),2))
		angleRow=["-".join(str(each) for each in threeEquiv),angle]
		print "\t".join(angleRow)	
