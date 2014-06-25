for i in 1 2 3 4 5 6; do cd ${i}sym0PBE; echo ${i}sym0PBE >> ../magfile; cp ~/pythonscripts/printmag2.py .; python printmag2.py >> ../magfile; tail -n 1 OSZICAR >> ../magfile ; cd ../; done

