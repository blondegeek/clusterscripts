import re

file=open("EIGENVAL")
bands=[]

regex = re.compile("-?\d+.\d+")
bandtmp=[]

for i, line in enumerate(file):
        j=i-6
        if i > 6:
                if j%10 != 1 and j%10 != 0:
                        bandtmp.append(regex.findall(line)[0])
                if j%10 == 0:
                        bands.append(bandtmp)
                        bandtmp = []

file.close()

for m,band in enumerate(bands):
        strtmp = '\t'.join(map(str,band))
        print str(m) + "\t" + strtmp


