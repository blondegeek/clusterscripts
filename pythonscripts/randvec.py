import numpy as np
import itertools

vec = 2*np.random.random_sample((3,8))-1
norm = np.apply_along_axis(np.linalg.norm, 0, vec)
ready = np.transpose(np.round(vec/norm,2))
ready2 = np.round(list(itertools.chain.from_iterable(ready)),2)
out = ' '.join(map(str, ready2))
print '  MAGMOM = 120*0 ' + out
