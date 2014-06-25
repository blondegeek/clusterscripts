file=`ls *sjob | tail -n 1` 
echo "$file"
echo $(date) >> ~/joblog
sbatch $file >> ~/joblog
echo `pwd` >> ~/joblog
