#!/usr/bin/env bash

set -v

ml FIRESTARTER/2.0 firestarter-metric-metricq

elab ht enable
elab frequency 2500

SEQ1=$(seq 10 10 600)
SEQ2=$(seq 650 50 7680)
SEQ=$(echo -e "$SEQ1\n$SEQ2")

echo "$SEQ"

# preheat
FIRESTARTER -t 120

measurement() {
	elab frequency $1
	mkdir -p datafiles/$1

	for n in $SEQ
	do
		# line count of both threads! (times X + 2*23B for used inner loop size for both threads)
		# X is 15B for REG:1, 16B for L1_L and 16B for L1_LS_256
		FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 10 --run-instruction-groups=L1_L:1 --set-line-count=$n | tail -n 5 > datafiles/$1/$n.csv
		#FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 240 --start-delta=120000 --run-instruction-groups=REG:1 --set-line-count=360 | tail -n 5 > datafiles/op.csv
		#FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 240 --start-delta=120000 --run-instruction-groups=REG:1 --set-line-count=1536 | tail -n 5 > datafiles/l1.csv
		#FIRESTARTER --metric-path=libmetric-metricq.so --measurement -t 240 --start-delta=120000 --run-instruction-groups=REG:1 --set-line-count=15360 | tail -n 5 > datafiles/l2.csv
	done
}

measurement 2500
measurement 2200
measurement 1500
