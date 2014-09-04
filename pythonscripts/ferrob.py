import numpy as np
import itertools
from sys import argv

mag=float(argv[1])
mag2=float(argv[2])

thing=[]
for i in range(0,8):
	thing.append([0, 1, 0])
thing2=np.asarray(thing)

readysmall=[]
readybig=[]
for i, each in enumerate(thing):
	readysmall.append([x*mag for x in each])
	readybig.append([x*mag2 for x in each])
ready2 = np.round(list(itertools.chain.from_iterable(readysmall)),3)
ready3 = np.round(list(itertools.chain.from_iterable(readybig)),3)
out = ' '.join(map(str, ready2))
print ' M_CONSTR = 120*0 ' + out
print ' MAGMOM = 120*0 ' + out

out = ' '.join(map(str, ready3))
print ' M_CONSTR = 120*0 ' + out
print ' MAGMOM = 120*0 ' + out
