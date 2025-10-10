#!/bin/bash
export OMP_NUM_THREADS=32
export OMP_PLACES=cores
export OMP_PROC_BIND=close
rm -rf bench_multipatch hpctoolkit-*
mpiexec --map-by numa --bind-to numa -n 2 hpcrun -e CPUTIME -t ./cactus_qbd-sim-cpu bench_multipatch.par
hpcstruct hpctoolkit-cactus_qbd-sim-cpu-measurements
hpcprof hpctoolkit-cactus_qbd-sim-cpu-measurements
