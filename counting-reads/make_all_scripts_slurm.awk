BEGIN { FS = "\t" }  # use tab for field separator
    { ERRnumber=$1  # ERR# is first field
       lane=$2
       type=$3
       replicate=$4
       # make string rep_type, e.g., 01_WT
       rep_type=sprintf("%s_%02d",type,replicate)  
       ERRfile=ERRnumber ".fastq.gz"    # fastq file name
       # use array with rep_type as index; 
       # append file if element exists, otherwise create it
       if (rep_type in repfiles)
           repfiles[rep_type]=(repfiles[rep_type] "," ERRfile)
       else
           repfiles[rep_type]=ERRfile
}
# now loop through array and make shell scripts
# one shell script per replicate
END { for (repshort in repfiles) {
        repname="yeast_" repshort 
        rep_sh_name=repname ".sh"
        print  "#!/bin/sh" > rep_sh_name
        print "#SBATCH -A e31265" > rep_sh_name
        print "#SBATCH -p short" > rep_sh_name
        print "#SBATCH -N 1" > rep_sh_name
        print "#SBATCH -n 12" > rep_sh_name
        print "#SBATCH -t 01:00:00" > rep_sh_name
        print "#SBATCH --mem=10gb" > rep_sh_name
        print "#SBATCH --job-name=\"" repname "\"" > rep_sh_name
        print " " > rep_sh_name
        print "cd $SLURM_SUBMIT_DIR" > rep_sh_name
        print " " > rep_sh_name
        print "module purge all" > rep_sh_name
        print "module load STAR" > rep_sh_name
        print "STAR --genomeDir ./  --readFilesPrefix /projects/e31265/daw9026/yeast-data/raw-data/ --readFilesIn " repfiles[repshort] "  --readFilesCommand \"gzip -cd\" --outFileNamePrefix " repname "_ --runThreadN 12 --outFilterType BySJout --quantMode GeneCounts --outSAMtype None" > rep_sh_name
        print " " > rep_sh_name
    }
}
