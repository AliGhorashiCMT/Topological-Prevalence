#!/bin/bash
calcname=$1
nbands=$3
kidx=$4
sgnum=$2

export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
mpirun --quiet mpb-mpi $(cat ../symeigs/input/${calcname}.sh) res=256 nbands=$nbands kidx=$kidx epsin=1.01 kvecs="\"kpoints-sgnum$sgnum.dat\"" \
fourier-lattice-lightline.ctl 2>&1 | tee logs/${calcname}-lightline.log
unset IFS;
runtype=$(grep "run-type=" ../symeigs/input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" ../symeigs/input/${calcname}.sh | sed 's/res=//') # get resolution
cat logs/${calcname}-lightline.log | . get-freqs.sh $runtype ${calcname}-dispersion-lightline.out
