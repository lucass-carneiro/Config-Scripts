#!/bin/bash

singularity \
    -vvv shell \
    --cleanenv \
    --bind /var/spool \
    --bind /project \
    --bind /ddnB/project \
    --bind /etc/ssh/ssh_known_hosts \
    --bind /ddnB/work \
    --bind /work \
    --bind /scratch \
    /work/sbrandt/images/etworkshop2.simg
