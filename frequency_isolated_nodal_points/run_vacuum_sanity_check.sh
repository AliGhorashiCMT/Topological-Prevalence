#!/bin/bash
#SBATCH --exclusive
#SBATCH -n 24
#SBATCH -o analyze_nodal_points_sanity_check.out
source /etc/profile
module load mpi
#export sg=$SLURM_ARRAY_TASK_ID
export PYTHONPATH="/home/gridsan/aligho/.local/lib/python3.8/site-packages/PyNormaliz-2.15-py3.8-linux-x86_64.egg"
julia ./run_vacuum_sanity_check.jl
