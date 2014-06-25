file=`ls *sjob | tail -n 1` 
echo "$file"
echo ${1}
echo $(date) >> ~/joblog
sbatch --dependency=afterok:${1} $file >> ~/joblog
echo `pwd` >> ~/joblog
