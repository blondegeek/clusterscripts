#get bands
band1=$1
band2=$2
#get wavefunction
./WaveTransPlotMod -b $band1 > WAVE_band${band1}.tmp
./WaveTransPlotMod -b $band2 > WAVE_band${band2}.tmp

#paste wavefunctions together for awk awesomeness
paste WAVE_band${band1}.tmp WAVE_band${band2}.tmp | awk '{ print $1, $2, $3, $4, $5, $9, $10 }' > WAVE_band${band1}_band${band2}_new.tmp

#awk to the rescue!
#compute real and imaginary coeffs
awk '{a=$4*$6+$5*$7; b=$4*$7-$5*$6; Xr=a*$1; Xi=b*$1; Yr=a*$2; Yi=b*$2; Zr=a*$3; Zi=b*$3; print Xr "\t" Xi "\t" Yr "\t" Yi "\t" Zr "\t" Zi "\t" a "\t" b}' WAVE_band${band1}_band${band2}_new.tmp > results
#
#sum real and imaginary coeffs
realX=`awk '{x+=$1}END{print x}' results`
imagX=`awk '{x+=$2}END{print x}' results`
realY=`awk '{x+=$3}END{print x}' results`
imagY=`awk '{x+=$4}END{print x}' results`
realZ=`awk '{x+=$5}END{print x}' results`
imagZ=`awk '{x+=$6}END{print x}' results`

totala=`awk '{x+=$7}END{print x}' results`
totalb=`awk '{x+=$8}END{print x}' results`
#convert scientific notation since bc can't read it

function sciconvert() {
        result=`echo ${1} | sed 's/[E,e]/\\*10\\^/' | sed 's/+//'`
        result=`echo "scale = 15 ; $result" | bc`
        echo "$result"
}

realX=`sciconvert $realX`
imagX=`sciconvert $imagX`
realY=`sciconvert $realY`
imagY=`sciconvert $imagY`
realZ=`sciconvert $realZ`
imagZ=`sciconvert $realZ`

#take the norm squared of the dipole transition matrix elements -- basically the dot product of the complex vector
echo "$realX^2 + $imagX^2 + $realY^2 + $imagY^2 + $realZ^2 + $imagZ^2" | bc
echo "$totala" "$totalb"
#
#clean up!
#rm results
rm WAVE_band${band1}.tmp
rm WAVE_band${band2}.tmp
#rm WAVE_band${band1}_band${band2}_new.tmp
