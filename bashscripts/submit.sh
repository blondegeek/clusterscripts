file=`ls *sjob` 
for each in $file
do
	echo "$file"
	echo $(date) >> ~/joblog
	sbatch $file >> ~/joblog
	echo `pwd` >> ~/joblog
done
