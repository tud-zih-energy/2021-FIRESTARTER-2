#!/usr/bin/env bash

ml FIRESTARTER/2.0 firestarter-metric-metricq

elab frequency 2500
FIRESTARTER --optimize=NSGA2 -t 10 --preheat=240 --optimization-metric=metricq,perf-ipc --metric-path=libmetric-metricq.so --individuals=40 --generations=20 --nsga2-m=0.35
elab frequency 2200
FIRESTARTER --optimize=NSGA2 -t 10 --preheat=240 --optimization-metric=metricq,perf-ipc --metric-path=libmetric-metricq.so --individuals=40 --generations=20 --nsga2-m=0.35
elab frequency 1500
FIRESTARTER --optimize=NSGA2 -t 10 --preheat=240 --optimization-metric=metricq,perf-ipc --metric-path=libmetric-metricq.so --individuals=40 --generations=20 --nsga2-m=0.35
