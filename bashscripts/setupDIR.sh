check=BAND
check2=LIOH1
mag1=0.3
mag2=0.7
python randvec.py $mag1 $mag2 > tmp
python antiferroinvbreak.py $mag1 $mag2 >> tmp
python ferrob.py $mag1 $mag2 | tail -n 2 >> tmp
python ferroa.py $mag1 $mag2 | tail -n 2 >> tmp
python invbreak.py $mag1 $mag2 >> tmp
python ferro.py $mag1 $mag2 >> tmp
#for dir in LIOH1 LIOH1_relax
for dir in LIOH1
do
	mkdir $dir
#	for U in randsmall randbig ferrosmall ferrobig
#	for U in antimirrorabreaksmall antimirrorabreakbig
	for U in ferroabig ferrobbig
	do
		mkdir ${dir}/$U
		for folder in step1 step2 BAND
		do
			mkdir ${dir}/${U}/${folder}
			cp POSCARs/${dir}_POSCAR ${dir}/${U}/$folder/POSCAR
			cp POSCARs/${dir}_POTCAR ${dir}/${U}/$folder/POTCAR
			cp ${folder}_INCAR ${dir}/${U}/$folder/INCAR
		 	echo " LDAUU = 0 0 2" >> ${dir}/${U}/$folder/INCAR
			
			if [ "$U" == "randsmall" ]
			then
				cat tmp | head -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "randbig" ]
			then
				cat tmp | head -n 4 | tail -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "ferrosmall" ]
			then
				cat tmp | tail -n 4 | head -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "ferrobig" ]
			then
				cat tmp | tail -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "antimirrorabreaksmall" ]
			then
				cat tmp | head -n 6 | tail -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "antimirrorabreakbig" ]
			then
				cat tmp | head -n 8 | tail -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "invbreaksmall" ]
			then
				cat tmp | tail -n 8 | head -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "invbreakbig" ]
			then
				cat tmp | tail -n 6 | head -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "ferroabig" ]
			then
				cat tmp | tail -n 10 | head -n 2 >> ${dir}/${U}/${folder}/INCAR
			elif [ "$U" == "ferrobbig" ]
			then
				cat tmp | head -n 10 | tail -n 2 >> ${dir}/${U}/${folder}/INCAR
			fi
			
			if [ "$folder" != "$check" ]
			then
				cp ${dir}_KPOINTS ${dir}/${U}/$folder/KPOINTS
			else
				cp BAND_KPOINTS ${dir}/${U}/$folder/KPOINTS
			fi
			cp ${folder}_sjob ${dir}/${U}/$folder/.
		done
	done
done
