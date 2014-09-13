filename=$1
awk 'BEGIN{i=1} /imag/,\
                /\/imag/ \
                 {a[i]=$2 ; b[i]=$3 ; c[i]=$4 ; d[i]=$5 ; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j],c[j],d[j]}' $filename > ${filename}_imag.dat

awk 'BEGIN{i=1} /real/,\
                /\/real/ \
                 {a[i]=$2 ; b[i]=$3 ; c[i]=$4 ; d[i]=$5; i=i+1} \
     END{for (j=12;j<i-3;j++) print a[j],b[j],c[j],d[j]}' $filename > ${filename}_real.dat


paste ${filename}_real.dat ${filename}_imag.dat > ${filename}_epsilon.dat
awk '{k=sqrt(-$2+sqrt($2^2+4*$6^2/4)); n=sqrt($2+k^2); R=(n^2+k^2+1-2*n)/(n^2+k^2+1+2*n); print $1 "\t" R}' ${filename}_epsilon.dat > ${filename}_Rw.dat

