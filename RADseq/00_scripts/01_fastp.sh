#!/usr/bin/env bash
#PBS -q sequentiel
#PBS -l walltime=00:10:00
#PBS -J 1-145
#PBS -l mem=40g
#PBS -N 01_Filtering_Rad


#declare variables used in the script
DATADIRECTORY=
DATAINPUT=$SCRATCH/sars_rad/02_data
DATAOUTPUT=$SCRATCH/sars_rad/03_trimmed
LOG=$DATADIRECTORY/98_log/01_fastp

FASTP=""
ADAPTERFILE=$DATADIRECTORY/00_scripts/adapters.fasta

mkdir -p $DATAOUTPUT
mkdir -p $LOG

NAME=$(cat $DATADIRECTORY/00_scripts/00_base_fastp.txt | awk "NR==${PBS_ARRAY_INDEX}")

#save array table correspondance
echo -e ${PBS_ARRAY_INDEX}"\t"${NAME} >> $DATADIRECTORY/00_scripts/01_fastp_array_table.txt


$FASTP
cd $DATAINPUT
fastp -i $DATAINPUT/${NAME}.1.fq.gz -I $DATAINPUT/${NAME}.2.fq.gz -o $DATAOUTPUT/${NAME}_R1_paired.fastq.gz -O $DATAOUTPUT/${NAME}_R2_paired.fastq.gz --adapter_fasta $ADAPTERFILE --trim_poly_g --average_qual 28 --length_required 50 &> $LOG/fastp_${NAME}.log





