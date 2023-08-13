# ESAM 472 Overview

## Yeast Experiment

The purpose of this class was to eventually do differential expression analysis
on yeast sequencing data. We looked at 6 biological replicates for 2
conditions with 7 technical replicates (84 total files). Each person in the
class got 6 biological replicates for each condition (6 technical replicates for
wild type and 6 for mutant). 

ENA Project: https://www.ebi.ac.uk/ena/browser/view/PRJEB5348
Paper Link: https://academic.oup.com/bioinformatics/article/31/22/3625/240923

## Downloading the Data

The biological replicates used were WT 01, WT 31, WT 33, WT 37, WT 47, WT 48
and SNF2 01, SNF2 22, SNF2 26, SNF2 31, SNF2 34, SNF2 43. The script 
extract_my_samples.awk in get-sample-names takes a mapping file gives you the 
run numbers for each technical replicate for each biological replicate i.e.
technical replicates 1-7 for WT 01. 

Once you have the run numbers, you can use different tools to get the data. I
tested out 5 different ways working on the cluster I was on at the time. See
this [file](/download-data/downloading_data.md) for code snippets and details.

## Creating Quality Control Reports

We used FastQC and MultiQC to generate quality control reports. To create a pdf
report, you need pandoc and a TeX distribution. Then you can call

```
multiqc --pdf .
```

## Aligning

### Building an Index

We used a reference yeast genome and annotation from Ensembl at 

https://ftp.ensembl.org/pub/release-107/fasta/saccharomyces_cerevisiae/dna/Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa.gz (reference)

https://ftp.ensembl.org/pub/release-107/gtf/saccharomyces_cerevisiae/Saccharomyces_cerevisiae.R64-1-1.107.gtf.gz (annotation)

Note, these need to be edited to have chr prefixed to the chromosome names if you want to use them in Integrative Genomics Viewer (IGV).

Run the script build_star_index.sh to create the index.

### Aligning Reads for IGV

As an example, we have code that aligns reads from WT 01. Using the files from the index building step, you can call
align_WT_01.sh. This will create a .bam file as well as a .bam.bai file. These are what one needs to look at the
alignments in IGV.

## Create Count Tables

We again are going to align reads but limit ourselves to just the read counts for each gene. No need to take up space with .bam files if we are not going to use IGV. The number of reads will
be a measure of expression of a gene. We also do this for all 6 wild type and mutant replicates. This entails automating
the counting process. The steps were as follows:

1) Create table from ERP004763_sample_mappings.tsv with columns errnum, techrep,
type, and biorep using extract_my_samples.awk but making sure the print statements
do not specify a column.

2) Call make_all_scripts_slurm.awk with the file created in the previous step as an argument
to create alignment job submission scripts for each biological replicate

3) Create a file called scripts_to_submit.txt with the script names created in the previous step (one name on each line)

4) Call make_master_submit_slurm.awk to create the master submission file

5) The master submission file ensures each alignment is done one after the other to ensure you do not run out of temporary disk space and get corrupted files

6) Create a file called read_count_tables_to_build_table.txt with the ReadsPerGene.out.tab file names (one name on each line)

7) Create the final count table by calling build_count_table.awk with read_count_tables_to_build_table.txt as the argument

## Differential Expression Analysis






