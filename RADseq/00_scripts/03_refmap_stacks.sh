#!/usr/bin/env bash
#PBS -q omp
#PBS -l walltime=72:00:00
#PBS -l  mem=100g
#PBS -l ncpus=51
#PBS -N 03_refmap_stacks


#declare variables used in the script
DATADIRECTORY=
DATAINPUT=$SCRATCH/sars_rad/04_mapped
DATAOUTPUT=$DATADIRECTORY/05_stacks
LOG=$DATADIRECTORY/98_log/03_refmap_stacks

mkdir -p $DATAOUTPUT
mkdir -p $LOG

STACKS=""

$STACKS
ref_map.pl --samples $DATAINPUT --popmap $DATADIRECTORY/00_scripts/popmap_stacks.txt --out-path $DATAOUTPUT -T 50 -X "populations: -p 5 -r 0.80 --hwe --vcf --vcf-all --plink"





