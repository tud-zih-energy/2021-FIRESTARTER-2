#!/usr/bin/env bash

elab ht enable
elab frequency 2500

# GCC 10 does not work with older FIRESTARTER vesion
ml gcc/9.3.0

git clone https://github.com/tud-zih-energy/FIRESTARTER.git

cd FIRESTARTER
git checkout v1.7.4
git apply ../FS-1.7.4-Rome-denormals.patch

mkdir -p build
cd build

../code-generator.py
make -j

cd ../../

DENORMAL_FS=(./FIRESTARTER/build/FIRESTARTER)
NORMAL_FS=(FIRESTARTER --run-instruction-groups REG:1)

METRICQ=(metricq-summary --start-delta=120000 --stop-delta=2000 --)

ml FIRESTARTER/2.0 gcc metricq
mkdir -p datafiles

${METRICQ[@]} ${DENORMAL_FS[@]} -t 240 > datafiles/denormal_fs.data
sleep 240
${METRICQ[@]} ${NORMAL_FS[@]} -t 240 > datafiles/normal_fs.data
