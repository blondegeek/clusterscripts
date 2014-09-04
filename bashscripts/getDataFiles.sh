check=step1
check2=BAND
check3=step2

for dir in LIOH1
do
#	for U in randbig randsmall
#	for U in ferroabig invbreakbig invbreaksmall  
	for U in antimirrorabreakbig
	do
		#for folder in step1 BAND step2
		for folder in BAND
		do	
			if [ "$folder" == "$check" ]
			then
				cp ${dir}/${U}/${folder}/vasprun.xml RESULTS/${dir}_${U}_${folder}_vasprun.xml
			elif [ "$folder" == "$check2" ]
			then
				cd ${dir}/${U}/${folder}
				cp ~/pythonscripts/plot_band.py .
				python plot_band.py
				cp ~/pythonscripts/plot_pdos.py .
				python plot_pdos.py
				cd ../../../
				cp ${dir}/${U}/${folder}/band_structure.dat RESULTS/${dir}_${U}_${folder}_band_structure.dat
				cp ${dir}/${U}/${folder}/pdos.dat RESULTS/${dir}_${U}_${folder}_pdos.dat
			elif [ "$folder" == "$check3" ]
			then
				cp ${dir}/${U}/${folder}/OUTCAR RESULTS/${dir}_${U}_${folder}_OUTCAR
			fi
		done
	done
done
