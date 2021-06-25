#!/usr/bin/env bash

measure() {
	elab frequency $1
	mkdir -p $1
	cd $1

	FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 240 --start-delta=120000 --run-instruction-groups=RAM_L:9,L3_L:22,L2_L:29,L1_2LS_256:21,L1_LS_256:78,REG:46 | tail -n 5 > 2500.csv
	FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 240 --start-delta=120000 --run-instruction-groups=RAM_L:11,L3_L:23,L2_L:47,L1_2LS_256:64,L1_LS_256:86,REG:43 | tail -n 5 > 2200.csv
	FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 240 --start-delta=120000 --run-instruction-groups=RAM_L:11,L3_L:15,L2_L:74,L1_2LS_256:84,L1_LS_256:57,REG:18 | tail -n 5 > 1500.csv

	cd ..
}

ml FIRESTARTER/2.0 firestarter-metric-metricq

elab frequency 2500
FIRESTARTER -t 240

measure 2500
measure 2200
measure 1500
