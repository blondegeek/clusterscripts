#!/bin/bash

i=0

while [ $i -lt 2 ]
do
	qsub -I -q vulcan_batch $1
	pushd `dirname $1`
	git add *
	msg = `grep stress OUTCAR | tail -n 1`
	git commit -m "$msg"
	mv CONTCAR POSCAR
	sh ~/clean.sh
	popd
done
