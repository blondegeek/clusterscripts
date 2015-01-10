set term png
set output "dft.png"
set yrange [-10:10]
band(n) = sprintf ("band%d.dat", n)
plot for [i=1:12] band(i)using 2 with lines
