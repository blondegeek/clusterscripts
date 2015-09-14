
import numpy as np
import math
import pymatgen
from pymatgen.symmetry.finder import SymmetryFinder

s = pymatgen.read_structure('POSCAR2')

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


def getDistinctLengths(listOne,listTwo,length,tolerance,s,atomNumber,equiv):
	equivcounter=-1
	distances=list()
	for i in listOne:
		if equivcounter!=equiv[i]:
			equivcounter=equiv[i]
			neigh = s.get_neighbors_in_shell(s[i].coords,length,tolerance)
			for each in neigh:
				if each[2] in listTwo:
					distances.append([sorted([atomNumber[i],atomNumber[each[2]]]),round(each[1],5)])
	distinctDistances=list()
	map(lambda x: not x in distinctDistances and distinctDistances.append(x), distances)
	
	prettyDistinctDistances = [ ["-".join(str(e) for e in each[0]),str(each[1])] for each in distinctDistances]
	for each in prettyDistinctDistances:
	        print "\t".join(each)
	
	print "---------"

getDistinctLengths(iridiums,oxygens,2.0,0.5,s,atomNumber,equiv)
getDistinctLengths(lithiums,oxygens,2.0,0.5,s,atomNumber,equiv)
getDistinctLengths(iridiums,iridiums,3.0,0.5,s,atomNumber,equiv)
getDistinctLengths(lithiums,lithiums,3.0,0.5,s,atomNumber,equiv)
getDistinctLengths(lithiums,iridiums,3.0,0.5,s,atomNumber,equiv)

def getDistinctAngles(listOne,listTwo,length,tolerance,s,atomNumber,equiv):
	counter=[0,0,0]
	angleSet = []
	for i in listTwo[0::1]:
		thisONeigh=s.get_neighbors_in_shell(s[i].coords,length,tolerance)
		IrList=[site[2] for site in thisONeigh if site[2] in listOne]
		IrListCoord=[site[0] for site in thisONeigh if site[2] in listOne]
		IrOpt = sorted([atomNumber[IrList[0]],atomNumber[IrList[1]]])
		threeEquiv = [IrOpt[0],atomNumber[i],IrOpt[1]]
		A=s[i].coords-IrListCoord[0].coords
		B=s[i].coords-IrListCoord[1].coords
		angle=str(round(np.degrees(math.acos(np.dot(A,B)/(np.linalg.norm(A)*np.linalg.norm(B)))),2))
		angleRow=["-".join(str(each) for each in threeEquiv),angle]
		angleSet.append("\t".join(angleRow))
	for s in set(angleSet):
		print s
	print "---------"

getDistinctAngles(iridiums,oxygens,2,0.8,s,atomNumber,equiv)
