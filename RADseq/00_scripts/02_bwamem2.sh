#!/usr/bin/env bash
#PBS -q omp
#PBS -l walltime=05:00:00
#PBS -J 1-270
#PBS -l ncpus=21
#PBS -l mem=60gb
#PBS -N 02_bwa_mem2

#declare variables used in the script
DATADIRECTORY=
DATAINPUT=$SCRATCH/sars_rad/03_trimmed
DATAOUTPUT=$SCRATCH/sars_rad/04_mapped
GENOME=$DATADIRECTORY/01_info_files/GCA_903131615.1_diplodus_sargus_genome_genomic.fna
LOG=$DATADIRECTORY/98_log/02_bwa

BWA=""
SAMBAMBA=""
SAMTOOLS=""

TMPDIR=$SCRATCH
TEMPDIR=$SCRATCH

mkdir -p $DATAOUTPUT
mkdir -p $LOG

# Assign array nb to file
NAME=$(cat $DATADIRECTORY/00_scripts/00_base_fastp.txt | awk "NR==${PBS_ARRAY_INDEX}")
echo -e ${PBS_ARRAY_INDEX}"\t"${NAME} >> $DATADIRECTORY/00_scripts/02_bwa-mem2_array_table.txt

$BWA

cd $DATAINPUT
bwa-mem2 mem -t 20 -R "@RG\tID:${NAME}\tSM:${NAME}\tLB:${NAME}\tPL:ILLUMINA" $GENOME ${NAME}_R1_paired.fastq.gz ${NAME}_R2_paired.fastq.gz > $DATAOUTPUT/${NAME}.sam
conda deactivate


$SAMBAMBA
cd $DATAOUTPUT
sambamba view -t 20 -S -f bam ${NAME}.sam > ${NAME}.bam
rm ${NAME}.sam
conda deactivate

$SAMTOOLS
cd $DATAOUTPUT
samtools view --threads 20 -b -f 2 -F 256 ${NAME}.bam -o ${NAME}_filtered.bam
rm ${NAME}.bam
samtools sort --threads 20 ${NAME}_filtered.bam -o ${NAME}_filtered_sorted.bam
rm ${NAME}_filtered.bam

conda deactivate




