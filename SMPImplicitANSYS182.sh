#!/bin/bash
#PBS -z
#PBS -V
#PBS -l select=1:ncpus=8
cd $PBS_O_WORKDIR
"/usr/ansys_inc/v182/ansys/bin/mapdl"  -p aa_r -np 8 -b -i ANSYSInputFile.dat -o messag.out -d win32c