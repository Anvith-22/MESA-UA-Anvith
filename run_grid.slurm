#!/bin/bash

#SBATCH --job-name=GRID_NAME
#SBATCH --account=binboom
#SBATCH --partition=standard
#SBATCH --output=out_%A_%a.out
#SBATCH --error=error_%A_%a.err
#SBATCH --array=1-N_STARS
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END
#SBATCH --mail-user=akianvith@arizona.edu
#SBATCH --time=48:00:00

# filled in by the setup script: the only thing that varies is rotation
rot_pars=(LIST_ROT)

num_runs=${#rot_pars[@]}
echo "total runs" $num_runs

task_id=$((SLURM_ARRAY_TASK_ID - 1))
ROT_VALUE=${rot_pars[$task_id]}

echo "SLURM_JOB_ID=$SLURM_JOB_ID - $SLURM_ARRAY_TASK_ID"
echo "Starting job: Omega/Omega_crit = $ROT_VALUE"

RUN_DIR=WHERE_TO_RUN/rot_${ROT_VALUE}/
cd $RUN_DIR || exit 1
mkdir -p png

export OMP_NUM_THREADS=8
export MESASDK_ROOT=/home/u21/akianvith/mesasdk-26.6.1
source $MESASDK_ROOT/bin/mesasdk_init.sh
export MESA_DIR=/home/u21/akianvith/mesa-26.04.1

echo "-------------"
hostname
echo "Run is in " $RUN_DIR
echo "MESA_DIR=" $MESA_DIR
gfortran --version
pwd
echo "-------------"

./clean
./mk
./rn
./clean
