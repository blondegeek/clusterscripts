echo $1
new=`sh ~/bashscripts/jerbquery.sh ${1} | sed -n 3p`
echo $new
cd $new
