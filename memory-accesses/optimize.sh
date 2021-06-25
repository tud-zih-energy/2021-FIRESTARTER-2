#!/bin/bash
# optimize on conway. select 1500MHz to avoid throtteling

set -v

elab ht enable
elab frequency 1500
ml FIRESTARTER/2.0 firestarter-metric-metricq

FIRESTARTER=(FIRESTARTER --individuals=40 --generations=25)
ARGS=(--optimization-metric metricq,perf-ipc --metric-path=libmetric-metricq.so -t 20 --optimize NSGA2)

# train FIRESTARTER with cache (only L1)

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups=L1_2LS_256:72,L1_LS_256:82,REG:75

# train FIRESTARTER with cache (only L1 and L2)

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups=L2_L:91,L1_2LS_256:72,L1_LS_256:82,REG:75

# train FIRESTARTER only with cache

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups=L3_L:25,L2_L:91,L1_2LS_256:72,L1_LS_256:82,REG:75

# train FIRESTARTER with cache and dram (we already did this: measurements/frequency-optimized/conway/conway_2021-04-29_18:49:50+0200.json)
