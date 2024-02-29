#!/bin/bash
calcname=$1
nbands=$3
sgnum=$2
export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
#mpirun --quiet mpb-mpi
mpb $(cat ../symeigs/input/${calcname}.sh) res=32 nbands=$nbands kvecs="\"kpoints-sgnum$sgnum.dat\"" \
fourier-lattice.ctl 2>&1 | tee logs/${calcname}.log
unset IFS;
runtype=$(grep "run-type=" ../symeigs/input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" ../symeigs/input/${calcname}.sh | sed 's/res=//') # get resolution
cat logs/${calcname}.log | . get-freqs.sh $runtype ${calcname}-dispersion.out
