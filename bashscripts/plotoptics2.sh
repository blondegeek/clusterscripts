filename=$1
awk 'BEGIN{i=1} /imag/,\
                /\/imag/ \
                 {a[i]=$2 ; b[i]=$3 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j]}' $filename > imag1.dat

awk 'BEGIN{i=1} /imag/,\
                /\/imag/ \
                 {a[i]=$2 ; b[i]=$4 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j]}' $filename > imag2.dat

awk 'BEGIN{i=1} /imag/,\
                /\/imag/ \
                 {a[i]=$2 ; b[i]=$5 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j]}' $filename > imag3.dat

awk 'BEGIN{i=1} /real/,\
                /\/real/ \
                 {a[i]=$2 ; b[i]=$3 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j]}' $filename > real1.dat

awk 'BEGIN{i=1} /real/,\
                /\/real/ \
                 {a[i]=$2 ; b[i]=$4 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j]}' $filename > real2.dat

awk 'BEGIN{i=1} /real/,\
                /\/real/ \
                 {a[i]=$2 ; b[i]=$5 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j]}' $filename > real3.dat

cat >plotfile<<!
# set term postscript enhanced eps colour lw 2 "Helvetica" 20
# set output "optics.eps"
set title "Ferro C"
plot [0:1] "imag1.dat" using (\$1):(\$2) w lp, "real1.dat" using (\$1):(\$2) w lp,\
           "imag2.dat" using (\$1):(\$2) w lp, "real2.dat" using (\$1):(\$2) w lp,\
           "imag3.dat" using (\$1):(\$2) w lp, "real3.dat" using (\$1):(\$2) w lp
!

gnuplot -persist plotfile
