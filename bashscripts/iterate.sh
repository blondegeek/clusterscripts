$file = `ls *job` 
git add *
git commit -m "`grep stress OUTCAR | tail -n 1`"
mv CONTCAR POSCAR
sh ~/clean.sh
echo $file
qsub -q vulcan_batch $file
