#!/bin/bash
calcname=$1
export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
#optionally put mpirun
mpirun --quiet mpb-mpi $(cat input/${calcname}.sh) kvecs="\"kpoints-$idx.dat\"" tol=1.0e-12 nbands=6 \
fourier-lattice.ctl 2>&1 | tee logs/${calcname}-$id.log
unset IFS;
runtype=$(grep "run-type=" input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" input/${calcname}.sh | sed 's/res=//') # get resolution
cat logs/${calcname}-$id.log | . get-freqs.sh $runtype ${calcname}-$id-dispersion.out
mv "$calcname-epsilon.h5" ./output/
