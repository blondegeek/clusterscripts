#! /bin/tcsh

set a=5.905
set b=8.437

foreach c (16.4 16.6 16.8 17.0 17.2 17.6 17.8) 

mkdir $c
cp INCAR POTCAR LIO_cstudy_job KPOINTS ./$ci
cd ./$c

rm POSCAR

cat > POSCAR <<EOF
LIOcstudy
  1.000 
     $a                    0.000000000000000    0.0000000000000000
     0.0000000000000000    $b                   0.0000000000000000
     0.0000000000000000    0.000000000000000    $c
EOF

cat ~/LIO_1_1_crun/positions >> POSCAR

sh ~/submit.sh

cd ../

end
