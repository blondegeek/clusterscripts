for c in {1..16}
do
        grep '  '$c'      ' EIGENVAL >  band$c.dat
done
