#for folder in randbig randsmall ferrobig ferrosmall antimirrorabreaksmall antimirrorabreakbig
for folder in randbig randsmall ferrosmall antimirrorabreakbig
do
	cd LIOH1/$folder/step1
	cp ~/pythonscripts/printmag2.py .
	echo $folder >> ../../../RESULTS/magfile_20140627.txt
	python printmag2.py >> ../../../RESULTS/magfile_20140627.txt
	cd ../../../
done
