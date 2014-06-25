file=`ls *sjob | tail -n 1` 
echo "$file"
echo ${1}
echo $(date) >> ~/joblog
qsub -W depend=afterok:${1} >> ~/joblog
#!sbatch --dependency=afterok:${1} $file >> ~/joblog
echo `pwd` >> ~/joblog
