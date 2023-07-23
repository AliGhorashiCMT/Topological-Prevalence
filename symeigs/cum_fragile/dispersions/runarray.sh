#!/bin/bash
##SBATCH -a 20132,20772,21152,21548,22488,23742,25243,27021,27163,28064,28159,28545,29229,29939
##SBATCH -a 16,32,64,128,192,256
#SBATCH -a 28,30
#SBATCH -o symeigs-%a.out
#SBATCH --exclusive
#SBATCH -n 48
source /etc/profile
module load mpi/openmpi-4.0.5
export res=$SLURM_ARRAY_TASK_ID
# We sweep the resolution to determine how much of our results depend on the discretization of the Fourier lattice
./runlattice.sh dim2-sg10-27163-res$res-te
