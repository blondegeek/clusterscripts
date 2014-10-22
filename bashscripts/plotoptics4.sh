filename=$1

cat >plotfile<<!
set term postscript enhanced eps colour lw 2 "Helvetica" 20
set output "${filename}.eps"
set title "$filename"
plot [0:3] "${filename}" using (\$1):(\$2) w lp
!

gnuplot -persist plotfile
