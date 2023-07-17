#!/bin/bash
calcname=$1 #Name of calculation in ../symeigs/input
outname=$2 #Prefix name of outputted calculation 
sgnum=$3 # Spacegroup number
mode=$4 # Mode (te, tm)
einxx=$5 #xx component of epsilon_in
einyy=$6 #yy component of epsilon_in
einzz=$7 #zz component of epsilon_in
g=$8 #parameter parameterizing the strength of the magnetic field
gidx=$9 #Index corresponding to the strength of the magnetic field (g) 

export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
export epsindiag="$einxx $einyy $einzz"
export epsinoffdiag="0+${g}i 0 0" # Off diagonal imaginary component induced by magnetic field
export epsoutoffdiag="0 0 0" #Epsout is vacuum 
export epsoutdiag="1 1 1"
mpb $(cat ../symeigs/input/${calcname}.sh) epsin-diag="(vector3 $epsindiag)" epsin-offdiag="(cvector3 $epsinoffdiag)" \
epsout-diag="(vector3 $epsoutdiag)" epsout-offdiag="(cvector3 $epsoutoffdiag)" \
fourier-lattice.ctl 2>&1 | tee logs/${outname}.log
unset IFS;
runtype=$(grep "run-type=" ../symeigs/input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" ../symeigs/input/${calcname}.sh | sed 's/res=//') # get resolution

cat logs/${outname}.log | . get-freqs.sh $runtype ${outname}-dispersion.out
cat logs/${outname}.log | . get-symeigs.sh ${outname}-symeigs.out

mv ./output/${outname}-dispersion.out ./output/sg$sgnum/$mode/g${gidx}/${outname}-dispersion.out
mv ./output/${outname}-symeigs.out ./output/sg$sgnum/$mode/g${gidx}/${outname}-symeigs.out

