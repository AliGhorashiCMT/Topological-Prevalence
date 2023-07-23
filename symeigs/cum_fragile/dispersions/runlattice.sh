#!/bin/bash
calcname=$1
export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
mpirun --quiet mpb-mpi $(cat input/${calcname}.sh) tol=1.0e-12 \
fourier-lattice.ctl 2>&1 | tee logs/${calcname}.log
unset IFS;
runtype=$(grep "run-type=" input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" input/${calcname}.sh | sed 's/res=//') # get resolution
cat logs/${calcname}.log | . get-freqs.sh $runtype ${calcname}-dispersion.out
cat logs/${calcname}.log | . get-symeigs.sh ${calcname}-symeigs.out
mv "$calcname-epsilon.h5" ./output/
