#!/bin/sh
#SBATCH -A
#SBATCH -p short
#SBATCH -N 1
#SBATCH -n 12
#SBATCH -t 1:00:00
#SBATCH --mem=10gb
#SBATCH --job-name="run_fastqc"

# load module
module load fastqc

# Set working directory
cd $SLURM_SUBMIT_DIR

# The command to execute:
fastqc -t 12 ../yeast_data/raw-data/*.fastq.gz
