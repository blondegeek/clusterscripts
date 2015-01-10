import numpy as np

data = []
curQ = None
curF = None
freqArray = []
disArray = []

with open("phonons.txt") as Textfile:
    for line in Textfile:
        line = line.split()
        trigger =  line[0] 
        if trigger == "q":
            if curQ != None:
                freqArray.append([curF, disArray])
                data.append([curQ, freqArray])
                freqArray = []
                curF = None
                disArray = []
            curQ = map( float, line[2:])
        elif trigger == "freq":
            if curF != None:
                freqArray.append([float(curF), disArray])
                disArray = []
            curF = float(line[4])
        elif trigger == "(":
            disArray.append( map( float, line[2::2]))
# Catch the last bits of data
freqArray.append([curF, disArray])
data.append([curQ, freqArray])

#first q vector array
print "***********"
print data[0]
#second q vector array
print "***********"
print data[1]
#second q vector
print "***********"
print data[1][0]
#second q vector frequency array
print "***********"
print data[1][1]
#first frequency vector and displacement array of second q vector
print "***********"
print data[1][1][0]
#first displacement vector of first frequency of second q vector
print "***********"
print data[1][1][0][1][0]
