#!/bin/bash
basename=$1
calcname=$2
epsidx=$3
eps=$4
sg=$5

export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
export basename
export epsidx
export eps
export sg
echo "basename is $basename"
echo "calcname is: $calcname"
echo "eps: $eps"
echo "epsidx: $epsidx"
mpb $(cat input/${basename}.sh) epsin=$eps \
fourier-lattice.ctl 2>&1 | tee logs/${calcname}.log
unset IFS;
runtype=$(grep "run-type=" input/${basename}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" input/${basename}.sh | sed 's/res=//') # get resolution
cat logs/${calcname}.log | . get-freqs.sh $runtype ${calcname}-dispersion.out
cat logs/${calcname}.log | . get-symeigs.sh ${calcname}-symeigs.out
mv ./output/${calcname}-symeigs.out ./output/sg$sg/eps$epsidx/$runtype/${calcname}-symeigs.out
mv ./output/${calcname}-dispersion.out ./output/sg$sg/eps$epsidx/$runtype/${calcname}-dispersion.out
