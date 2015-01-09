import matplotlib.cm as cm
import matplotlib.pyplot as plt
import numpy as np

with open("temp.dat") as Textfile:
    data = np.array([map(float,line.split()) for line in Textfile])

x = data[:,0]
y = data[:,1]
z = data[:,2]

print data.shape
print x

cmap = cm.jet

fig = plt.figure(1)
fig.clf()
ax = fig.add_subplot(1,1,1)

ax.scatter(x, y, c=z, cmap=cmap)

plt.draw()
plt.show()
fig.savefig('plottest.png', dpi=80)
