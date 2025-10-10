#! /bin/bash
#SBATCH --job-name=headon-multipatch
#SBATCH --time=3-00:00:00
#SBATCH --nodes=8
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=16
#SBATCH --account=loni_carpetx
#SBATCH --partition=workq
#SBATCH --exclusive

export SIM_OUT_DIR=${SLURM_JOB_NAME}
export PARFILE=$HOME/${SLURM_JOB_NAME}.par

export CACTUS_ROOT=/ddnB/project/sbrandt/carpetx/lts/CapyrX/Cactus
export CACTUS_EXE=${CACTUS_ROOT}/exe/cactus_qbd-sim-cpu
export CACTUS_SIMDIR=/work/lts/simulations
export CACTUS_SING_WRAPPER=/home/lts/cactus_sing.sh

echo "Preparing:"
set -x # Output commands
set -e # Abort on errors

module purge
module load mpich

cd ${CACTUS_SIMDIR}

if [ -d ${SIM_OUT_DIR} ]; then
    rm -rf ${SIM_OUT_DIR}
fi

mkdir ${SIM_OUT_DIR}
cd ${SIM_OUT_DIR}

echo "Node list:"
scontrol show hostnames ${SLURM_NODELIST}
echo

# Build machine file
echo "Generating machinefile"
echo

scontrol show hostnames ${SLURM_NODELIST} > hosts.${SLURM_JOB_ID}

for node in $(cat hosts.${SLURM_JOB_ID}); do
  echo "$node:$SLURM_NTASKS_PER_NODE" >> machinefile.$SLURM_JOB_ID
done
echo

echo "Generated machinefile:"
cat machinefile.${SLURM_JOB_ID}
echo

echo "Environment:"
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores
export OMP_PROC_BIND=close

env | sort > env.txt

echo "Starting:"
echo $(date +%s)

time mpiexec \
  -f machinefile.$SLURM_JOB_ID \
  -ppn $SLURM_NTASKS_PER_NODE \
  -genvlist OMP_NUM_THREADS,OMP_PLACES,OMP_PROC_BIND \
  --bind-to numa \
  --map-by numa \
  singularity exec --bind /var/spool --bind /project --bind /ddnB/project --bind /etc/ssh/ssh_known_hosts --bind /ddnB/work --bind /work --bind /scratch /work/sbrandt/images/etworkshop2.simg ${CACTUS_SING_WRAPPER} ${CACTUS_EXE} ${CACTUS_PARFILE}

echo "Stopping:"

mv ${SLURM_SUBMIT_DIR}/slurm-${SLURM_JOB_ID}.out slurm.out
echo $(date +%s)

echo "Done."
