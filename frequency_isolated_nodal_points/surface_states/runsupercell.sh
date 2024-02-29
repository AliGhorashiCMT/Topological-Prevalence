#!/bin/bash
calcname=$1
export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
# --quiet is to prevent mpi warnings 
mpirun --quiet mpb-mpi $(cat input/${calcname}.sh)  $(cat input/dim2-sg2-20481-res16-tm-clad.sh) cladding=25.5 nbands=2 supercell="(vector3 100 1)" \
supercell-lattice.ctl 2>&1 | tee logs/${calcname}.log
unset IFS;
runtype=$(grep "run-type=" input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" input/${calcname}.sh | sed 's/res=//') # get resolution
cat logs/${calcname}.log | . get-freqs.sh $runtype ${calcname}-dispersion.out
#mv "$calcname-supercell-epsilon.h5" ./output/
