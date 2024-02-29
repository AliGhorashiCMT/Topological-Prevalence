#!/bin/bash
#SBATCH -n 30
#SBATCH -N 1
##SBATCH --partition=xeon-g6-volta
#SBATCH -o mpb-calculation.o ## Make one output file for all members of job array since otherwise file management becomes cumbersome
#SBATCH --exclusive

source /etc/profile
module purge
module load mpi

#./runsupercell.sh dim2-sg16-20649-res64-tm
#./runsupercell.sh dim2-sg2-26398-res64-tm
./runsupercell.sh dim2-sg2-26398-res16-tm
