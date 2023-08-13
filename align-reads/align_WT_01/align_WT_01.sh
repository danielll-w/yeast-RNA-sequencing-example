#!/bin/sh
#SBATCH -A
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 01:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="WT_01_align"

# load STAR & samtools, set working directory, and run STAR, then samtools
module load STAR
module load samtools
#cd $SLURM_SUBMIT_DIR

# STAR command -- should be all on ONE LINE with commas and no spaces between fastq.gz files
STAR --genomeDir /genomeDir/ --readFilesPrefix /WT_01_data/ --readFilesIn ERR458493.fastq.gz,ERR458494.fastq.gz,ERR458495.fastq.gz,ERR458496.fastq.gz,ERR458497.fastq.gz,ERR458498.fastq.gz,ERR458499.fastq.gz --readFilesCommand "gzip -cd" --outFileNamePrefix yeast_WT_01 --runThreadN 12 --quantMode GeneCounts --outFilterType BySJout --outSAMtype BAM SortedByCoordinate --outFilterMultimapNmax 1
 
samtools index yeast_WT_01_Aligned.sortedByCoord.out.bam
