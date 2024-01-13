#!/bin/bash
calcname=$1
sg=$2
epsid=$3
residx=$4
swresolution=$5
savename=$6
export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
export swresolution
export savename
echo "calcname is: $calcname"
echo "calculation is being solved in ${savename}"
echo "real resolution is ${swresolution}"
mpb $(cat ../../symeigs/input/${calcname}.sh) res=${swresolution} \
fourier-lattice.ctl 2>&1 | tee logs/${savename}.log
unset IFS;
runtype=$(grep "run-type=" ../../symeigs/input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
cat logs/${savename}.log | . get-freqs.sh $runtype ${savename}-dispersion.out
cat logs/${savename}.log | . get-symeigs.sh ${savename}-symeigs.out

mv ./output/${savename}-symeigs.out ./output/sg$sg/eps$epsid/$runtype/res${residx}/${savename}-symeigs.out
mv ./output/${savename}-dispersion.out ./output/sg$sg/eps$epsid/$runtype/res${residx}/${savename}-dispersion.out
