files=`find -type d -name \*lsoff\* | cut -c3-`
for f in $files
do
    cd ${f}
    cp ~/pythonscripts/getmag.py .
    python getmag.py
    cp ~/pythonscripts/getorigmag.py .
    python getorigmag.py
    cd ../
    cp ${f}/data.pkl pickles/${f}.pkl
    cp ${f}/initialmag.pkl pickles/${f}initial.pkl
done
