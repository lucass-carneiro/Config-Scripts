#!/bin/bash

ALLOCATION=loni_cactus25
QUEUE=workq
WALLTIME=01:00:00

srun -u \
     -A $ALLOCATION \
     -p $QUEUE \
     --nodes 1 \
     --ntasks 64 \
     -t $WALLTIME \
     --exclusive \
     --pty bash -i

