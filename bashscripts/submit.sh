pathy=`pwd`

if squeue | grep tsmidt | awk '{ print $1 }' | xargs -n 1 sh ~/bashscripts/jerbquery.sh | grep -q $pathy
then
   echo "Job already running in this directory"
else
   file=`ls *sjob` 
   for each in $file
   do
   	echo "$file"
   	echo $(date) >> ~/joblog
   	sbatch $file >> ~/joblog
   	echo `pwd` >> ~/joblog
   done
fi
