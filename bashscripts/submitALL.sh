check=BAND
check2=step2
check3=step1
#for dir in LIOH1 LIOH1_relax
for dir in LIOH1
do
#	for U in randsmall randbig ferrosmall ferrobig
#	for U in antimirrorabreaksmall antimirrorabreakbig
	for U in ferroabig ferrobbig
	do
		jobid=0
		for folder in step1 BAND
		do
			cd ${dir}/${U}/${folder}
			if [ "$folder" == "$check" -o "$folder" == "$check2" ]
			then
				sh ~/bashscripts/submitdepjid.sh $jobid
			else
				sh ~/bashscripts/submit.sh
				if [ "$folder" == "$check3" ]
				then
					jobid=`squeue | grep tsmidt | awk '{ print $1 }' | sort -n | tail -n 1`	
				fi 
			fi
			cd ../../../
		done
	done
done
