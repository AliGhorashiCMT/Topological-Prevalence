#!/bin/bash
#SBATCH -a 20132,20772,21152,21548,22488,23742,25243,27021,27163,28064,28159,28545,29229,29939
#SBATCH -o symeigs-%a.out
#SBATCH --exclusive

#The arrays are indexed by ids of lattices with cumulatively fragile bands.
export id=$SLURM_ARRAY_TASK_ID
./runlattice.sh dim2-sg10-$id-res192-te
