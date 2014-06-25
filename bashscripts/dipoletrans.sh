band1=$1
band2=$2

echo "You have selected band $band1 and band $band2"

#get A1 A2 A3
#(lattice vectors)
latvec=`head -n 5 POSCAR | tail -n 3`

A1x=`echo "$latvec" | head -n 1 | awk '{ print $1 }'`
A1y=`echo "$latvec" | head -n 1 | awk '{ print $2 }'`
A1z=`echo "$latvec" | head -n 1 | awk '{ print $3 }'`
A2x=`echo "$latvec" | head -n 2 | tail -n 1 | awk '{ print $1 }'`
A2y=`echo "$latvec" | head -n 2 | tail -n 1 | awk '{ print $2 }'`
A2z=`echo "$latvec" | head -n 2 | tail -n 1 | awk '{ print $3 }'`
A3x=`echo "$latvec" | tail -n 1 | awk '{ print $1 }'`
A3y=`echo "$latvec" | tail -n 1 | awk '{ print $2 }'`
A3z=`echo "$latvec" | tail -n 1 | awk '{ print $3 }'`

echo $A1x $A1y $A1z


function sciconvert() {
	result=`echo ${1} | sed 's/E/\\*10\\^/' | sed 's/+//'`	
	result=`echo "scale = 40 ; $result" | bc`
	echo "$result"
}

function dipolemag() {
	a1=$1
	b1=$2
	a2=$3
	b2=$4
	c=$5
	mag=`echo "scale = 15 ; ${c}^2 * ( ( ${a1} * ${a2} + ${b1} * ${b2} )^2 + ( ${a1} * ${b2} - ${a2} * ${b1} )^2)" | bc`
	echo $mag
}


#get increments for sum grid
increment=`./WaveTransPlot | head -n 2 | tail -n 1 | awk '{ print $1 }'`
#convert value from scientific notation to form bc can read
increment=`sciconvert $increment`
# one mod increment
range=`echo "scale = 0 ; 1 / $increment" | bc`

echo "here"

#check if tmp file exists and erase if it does
if [ -f "dipole.tmp" ];
then
	rm dipole.tmp
fi
touch dipole.tmp

#check if WaveTransPlot exists
#if [ "WaveTransPlot" does not exist ];
#then
#	cp ~/fortranscripts/WaveTransPlot .
#fi



#loop through grid and WaveTransPlot queries
#Note that x y and z are in coordinates of a1 a2 and a3 not real space
#for i in `seq 0 ${range}`;
x=0
y=0
z=0
for i in `seq 0 ${range}`;
#for i in `seq 0 1`;
do
	x=`echo "$i * $increment" | bc`
	for j in `seq 0 ${range}`;
	#for j in `seq 0 1`;
	do
		y=`echo "$j * $increment" | bc`
		echo $x" "$y
		#query WaveTransPlot
		list1=`./WaveTransPlot -x ${x} -y ${y} -b ${band1}`
		list2=`./WaveTransPlot -x ${x} -y ${y} -b ${band2}`
		echo "$list1" > file1.tmp
		echo "$list2" > file2.tmp	
		newlist=`paste file1.tmp file2.tmp -d '\t'`
		#newlist=`paste <(echo "$list1") <(echo "$list2") -d '\t'`
		#need to get imag and real components out of each line
		z=0
		#paste --delimiters '' <(echo "$list1") <(echo "$list2") | while read line;
		echo "$newlist" | while read line;
		do
			real1=`echo "$line" | awk '{ print $2 }'`
			real1=`sciconvert $real1` 
			imag1=`echo "$line" | awk '{ print $3 }'`
			imag1=`sciconvert $imag1`
			real2=`echo "$line" | awk '{ print $5 }'`
			real2=`sciconvert $real2`
			imag2=`echo "$line" | awk '{ print $6 }'`
			imag2=`sciconvert $imag2`
			#echo $real1" "$imag1" "$real2" "$imag2" "
			X=`echo "scale = 15 ; $A1x*$x + $A2x*$y + $A3x*$z" | bc`
			Y=`echo "scale = 15 ; $A1y*$x + $A2y*$y + $A3y*$z" | bc`
			Z=`echo "scale = 15 ; $A1z*$x + $A2z*$y + $A3z*$z" | bc`
			#calculate the contribution from each vector component squared
			amplitudex=`dipolemag $real1 $imag1 $real2 $imag2 $X`
			amplitudey=`dipolemag $real1 $imag1 $real2 $imag2 $Y`
			amplitudez=`dipolemag $real1 $imag1 $real2 $imag2 $Z`
			#total sum is dot product of complex vectors
			amplitude=`echo "scale = 15 ; sqrt( $amplitudex + $amplitudey + $amplitudez )" | bc`
			#output to sum later
			echo $amplitude >> dipole.tmp
			#increment z
			z=`echo "$z + $increment" | bc`
		done
	done
done

#sum tmp file
paste -sd+ dipole.tmp | bc
