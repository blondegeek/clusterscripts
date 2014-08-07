file=`ls *pjob | tail -n 1`
echo "$file"
echo $(date) >> ~/jobfinished
echo `pwd` >> ~/jobfinished
