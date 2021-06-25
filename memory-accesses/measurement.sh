#!/usr/bin/env bash

ml FIRESTARTER/2.0 firestarter-metric-metricq

elab ht enable
elab frequency 1500

mkdir -p datafiles/{reg,l1,l2,l3,ram}

# we actually do calculation on double precision data, but fp_ret_sse_avx_ops.dp_mult_add_flops gives us 0 on our test system...
# the equivalent single precison event (fp_ret_sse_avx_ops.sp_mult_add_flops) works
FIRESTARTER=(perf stat -o perf.data -x ! -D 120000 -e ls_dc_accesses,fp_ret_sse_avx_ops.sp_mult_add_flops,instructions,cpu-cycles FIRESTARTER)
ARGS=(--measurement --metric-path=libmetric-metricq.so -t 240 --start-delta 120000)

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups REG:1 | tail -n 5 > datafiles/reg/firestarter.csv
mv perf.data datafiles/reg/perf.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups L1_2LS_256:99,L1_LS_256:1,REG:13 | tail -n 5 > datafiles/l1/firestarter.csv
mv perf.data datafiles/l1/perf.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups L2_L:80,L1_2LS_256:97,L1_LS_256:23,REG:16 | tail -n 5 > datafiles/l2/firestarter.csv
mv perf.data datafiles/l2/perf.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups L3_L:42,L2_L:50,L1_2LS_256:85,L1_LS_256:93,REG:1 | tail -n 5 > datafiles/l3/firestarter.csv
mv perf.data datafiles/l3/perf.data

${FIRESTARTER[@]} ${ARGS[@]} --run-instruction-groups RAM_L:11,L3_L:15,L2_L:74,L1_2LS_256:84,L1_LS_256:57,REG:18 | tail -n 5 > datafiles/ram/firestarter.csv
mv perf.data datafiles/ram/perf.data
