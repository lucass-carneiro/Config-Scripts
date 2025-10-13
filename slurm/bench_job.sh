#! /bin/bash
#SBATCH --job-name=bench_multipatch
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --cpus-per-task=4
#SBATCH --partition=medusa
#SBATCH --exclusive

export CACTUS_EXE_NAME=cactus_cactus-cpu-simd
export NUMA_DOMAINS_PER_NODE=2

export SIM_OUT_DIR=${SLURM_JOB_NAME}
export PARFILE=$HOME/${SLURM_JOB_NAME}.par

export CACTUS_ROOT=/home/lsanches/workspace/etk/CapyrX/Cactus
export CACTUS_EXE=${CACTUS_ROOT}/exe/${CACTUS_EXE_NAME}
export CACTUS_SIMDIR=/work/lsanches/simulations

echo "Preparing:"
set -x # Output commands
set -e # Abort on errors

module purge
spack env activate hpctool

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

export TASKS_PER_NUMA_DOMAIN=$((${SLURM_NTASKS_PER_NODE} / ${NUMA_DOMAINS_PER_NODE}))

env | sort > env.txt

echo "Starting:"
echo $(date +%s)

mpiexec \
  -f machinefile.$SLURM_JOB_ID \
  -ppn $SLURM_NTASKS_PER_NODE \
  -genvlist OMP_NUM_THREADS,OMP_PLACES,OMP_PROC_BIND \
  --bind-to numa \
  --map-by numa \
  hpcrun  \
  -e REALTIME \
  -e CYCLES \
  -e INSTRUCTIONS \
  -tt \
  ${CACTUS_EXE} -L 3 ${PARFILE}

echo "Running hpcstruct:"
hpcstruct hpctoolkit-${CACTUS_EXE_NAME}-measurements-${SLURM_JOB_ID}

echo "Running hpcprof:"
hpcprof hpctoolkit-${CACTUS_EXE_NAME}-measurements-${SLURM_JOB_ID}

echo "Stopping:"

mv ${SLURM_SUBMIT_DIR}/slurm-${SLURM_JOB_ID}.out slurm.out
echo $(date +%s)

echo "Done."
