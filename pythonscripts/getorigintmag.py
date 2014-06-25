import numpy as np
import sys
import csv
import re
import pickle

regex = re.compile("[-]?[0-1]\s")
fp = open("INCAR")

mag = []

for i, line in enumerate(fp):
	if i == 24:
		nums = regex.findall(line)
		mag.append(map(float,nums))

maglist =  mag[0]
magx = []
magy = []
magz = []

maglist.pop(0)

for i in range(0,len(maglist)):
	if i%3 == 0:
		magx.append(maglist[i])	
	elif i%3 == 1:
		magy.append(maglist[i])
	elif i%3 == 2:
		magz.append(maglist[i])

output = open('initialmag.pkl','wb')
pickle.dump( magx, output)
pickle.dump( magy, output)
pickle.dump( magz, output)
