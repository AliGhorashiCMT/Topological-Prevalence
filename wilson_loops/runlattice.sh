#!/bin/bash
calcname=$1
export OPENBLAS_NUM_THREADS=1
IFS=$'\n';
export calcname
echo "calcname is: $calcname"
#mpirun --quiet mpb-mpi $(cat input/${calcname}.sh) \
#fourier-lattice.ctl 2>&1 | tee logs/${calcname}.log
mpirun --quiet mpb-mpi $(cat input/${calcname}.sh) $(cat berry-ks-loops.sh) \
fourier-lattice.ctl 2>&1 | tee logs/${calcname}.log
unset IFS;
runtype=$(grep "run-type=" input/${calcname}.sh | sed 's/run-type=//;s/\"//g') # get polarization-string
res=$(grep "res=" input/${calcname}.sh | sed 's/res=//') # get resolution
. get-berry-phases.sh ${calcname}
