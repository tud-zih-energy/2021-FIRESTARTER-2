#!/bin/bash
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --exclusive
#SBATCH --threads-per-core=1
# get a 'normal' haswell node from island 6 (data analytics)
#SBATCH -C DA
#SBATCH -c 24
#SBATCH -A zihpraktikum
#SBATCH --time=1:00:00

set -v

module use ~/sw/x86_64/modulefiles

HOSTNAME=$(uname -n | awk -F. '{print $1;}')
METRIC="taurus.${HOSTNAME}.power"

echo "Using metricq-metric $METRIC"

export METRICQ_METRICS=$METRIC
export METRICQ_SERVER="amqps://...@rabbitmq.metricq.zih.tu-dresden.de"

export GOMP_NUM_THREADS=24

FIRESTARTER=(srun --cpu-freq=2000000 FIRESTARTER)
ARGS=(--measurement --metric-path=libmetric-metricq.so -t 240 --start-delta 120000)

module load FIRESTARTER/2.0-hswep-half-l3 firestarter-metric-metricq metricq

mkdir -p datafiles/haswell

g++ sqrt.cpp -fopenmp -o sqrt

srun --cpu-freq=2000000 metricq-summary --start-delta 120s --stop-delta 2s -- timeout 240 ./sqrt > datafiles/haswell/sqrt.data

srun --cpu-freq=2000000 metricq-summary --start-delta 120s --stop-delta 2s -- sleep 240 > datafiles/haswell/idle.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups REG:1 > datafiles/haswell/firestarter_register.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups L2_LS:20,L1_LS:53,REG:59 > datafiles/haswell/firestarter_cache_l2.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups L3_LS:17,L2_LS:12,L1_LS:98,REG:88 > datafiles/haswell/firestarter_cache.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups RAM_L:8,L2_LS:13,L1_LS:99,REG:23 > datafiles/haswell/firestarter_ram.data
