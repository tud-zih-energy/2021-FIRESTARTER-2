#!/bin/bash
# optimize on diana (basically same cpu, but higher frequency bin. select 2GHz)

set -v

elab frequency 2000
elab ht disable
ml FIRESTARTER/2.0-hswep-half-l3 firestarter-metric-metricq

FIRESTARTER=(FIRESTARTER --generations 25)
ARGS=(--optimization-metric metricq,perf-ipc --metric-path=libmetric-metricq.so -t 20 --optimize NSGA2)

# train FIRESTARTER with cache (only L1 and L2)

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups=L2_LS:9,L1_LS:90,REG:40

# train FIRESTARTER only with cache

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups=L3_LS:3,L2_LS:9,L1_LS:90,REG:40

# train FIRESTARTER with cache and dram

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups=RAM_L:2,L3_LS:3,L2_LS:9,L1_LS:90,REG:40
