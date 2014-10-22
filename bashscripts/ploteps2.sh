awk 'BEGIN{i=1} /HEAD OF MICRO/,\
                /XI_LOCAL/ \
                 {if ($4=="dielectric") {a[i]=$1 ; b[i]=$2 ; c[i]=$3 ; i=i+1}} \
     END{for (j=1;j<i;j++) print a[j],b[j],c[j]}' OUTCAR > chi0.dat

awk 'BEGIN{i=1} /INVERSE MACRO/,\
                /XI_TO_W/ \
                 {if ($4=="dielectric") {a[i]=$1 ; b[i]=$2 ; c[i]=$3 ; i=i+1}} \
     END{for (j=1;j<i;j++) print a[j],b[j],c[j]}' OUTCAR > chi.dat

cat >plotfile<<!
# set term postscript enhanced eps colour lw 2 "Helvetica" 20
# set output "optics.eps"

set xrange [0:10]

plot "chi0.dat" using (\$1):(-\$3) w lp lt  0 lw 2 pt 4 title "chi0 imag", \
     "chi.dat"  using (\$1):(-\$3) w lp lt  0 lw 2 pt 2 lc 1 title "chi  imag"
!

gnuplot -persist plotfile
