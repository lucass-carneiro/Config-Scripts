#!/usr/bin/bash

# This assume the device is named 3d:00.0. Do an lspci -k to find the actual name
echo 1 >| /sys/bus/pci/devices/0000\:3d\:00.0/remove
sleep 3
echo 1 >| /sys/bus/pci/rescan
