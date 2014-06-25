#! /bin/tcsh

set a=3.112

foreach i (4.972 4.977 4.987 4.992)

mkdir $a-$i
cp INCAR POTCAR job KPOINTS ./$a-$i
cd ./$a-$i

rm POSCAR

set b=`echo "scale=7; $i*0.50000" | bc`
set d=`echo "scale=7; $i*1.7320508/2.0000" | bc`

cat > POSCAR <<EOF
GaN
  1.000 
     $a                    0.000000000000000    0.0000000000000000
     $b                    $d                   0.0000000000000000
     0.0000000000000000    0.000000000000000    $i
   2   2
Selective dynamics
Direct
  0.00000000  0.00000000  0.00000000 F F F
  0.33333333  0.33333333  0.50000000 F F F
  0.00000000  0.00000000  0.37500000 T T T
  0.33333333  0.33333333  0.87500000 T T T
EOF

qsub job

cd ../

end
