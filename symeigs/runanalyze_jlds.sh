#!/bin/bash
#SBATCH -a 1,2,6,9,10,11,12,13,14,15,16,17
#SBATCH --exclusive
#SBATCH -o analyzejlds-%a.out
source /etc/profile

export sg=$SLURM_ARRAY_TASK_ID

julia ./analyze_jlds.jl $sg #For topologies (fragile, trivial, stable)
#julia ./analyze_corners.jl $sg
#julia ./analyze_corners_in_groups.jl $sg #For corner charges 
