band(n) = sprintf ("band%d.dat", n)
plot for [i=6:9] band(i)using 2 with lines
set output "dft.png"
pause -1
