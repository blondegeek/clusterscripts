file=`ls *sjob | tail -n 1` 
echo "$file"
echo $(date) >> ~/joblog
qsub $file >> ~/joblog
echo `pwd` >> ~/joblog
