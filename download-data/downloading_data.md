---
geometry: margin=1cm
---

# Optional Assignment 1

## wget from the ENA

I constructed a shell script that uses the extract_col7.awk script. This awk script takes column 7 from
filereport_read_run_PRJEB5348_tsv.txt and prepends wget to each entry. The entries then look like  

`wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR458/ERR458493/ERR458493.fastq.gz`.

As detailed in the previous section, I subset using a `grep` call to only the samples assigned to me. This subset of 
samples is listed in the file my_samples.

```
#!/bin/sh

awk -f extract_col7.awk filereport_read_run_PRJEB5348_tsv.txt | grep -f my_samples | fastq_download_script.sh
/bin/sh fastq_download_script.sh

```

## fastq-dump from NCBI

This shell script runs fastq on each technical replicate.

```
#!/bin/sh

# must have sratoolkit module loaded in for this to work

awk '{ print "fastq-dump --gzip " $1 }' get-sample-names/my_samples > fastq_dump_download_script.sh
/bin/sh fastq_dump_download_script.sh

```

## fasterq-dump from NCBI

This shell script takes each replicate number in the file my_samples, calls fasterq-dump on that replicate number, then
calls gzip on the output of fasterq-dump. We do this one replicate at a time so that the directory does not fill up with
many uncompressed files.

```
#!/bin/sh

while read p; do
  eval "fasterq-dump $p"
  eval "gzip ${p}.fastq"
done < get-sample-names/my_samples
```

## ascp from the ENA

I modified the extract_col7.awk script to create the ascp calls for each technical replicate.

```
BEGIN { FS="\t" }
/vol1/ {
  address=$7
  gsub("ftp.sra.ebi.ac.uk", "era-fasp@fasp.sra.ebi.ac.uk:", address)
  print "ascp -QT -l 300m -P33001 -i /software/aspera/3.10.0/.aspera/connect/etc/asperaweb_id_dsa.openssh " \
  address " ."
}
```

This awk script was used in this shell script where again we subset to only the relevenat replicates.

```
#!/bin/sh

awk -f extract_col7_ascp_version.awk filereport_read_run_PRJEB5348_tsv.txt | grep -f \
get-sample-names/my_samples > ascp_download_script.sh
/bin/sh ascp_download_script.sh
```


## globus from the ENA

I changed the extract_col7.awk script to prepend /gridftp/ena/.

```
BEGIN { FS="\t" }
/ERR/ { print "/gridftp/ena/" $7 }
```

Then, I used sed to get rid of everything between /ena and /fastq on each line and grep to subset to lines with my
samples. 

```
awk -f extract_col7_globus_version.awk filereport_read_run_PRJEB5348_tsv.txt | \
sed 's/ena.*\/fastq/ena''\/fastq/g' | \
grep -f get-sample-names/my_samples > globus_batch_sources.txt
```

The entries look like  

`/gridftp/ena/fastq/ERR459/ERR459206/ERR459206.fastq.gz` 

These are the source locations of the data.

To create the destination locations, I first created another awk script called create_destinations_for_globus.awk where
each entry corresponds to a certain technical replicate.

```
{ print "/yeast-data/" $1 ".fastq.gz" }
```

This awk script was called in this command

```
awk -f create_destinations_for_globus.awk get-sample-names/my_samples > globus_batch_destinations.txt
```
and each line looks like  
`/yeast-data/ERR459206.fastq.gz`

Finally to create the globus_batch.txt file which is used in our final globus CLI command, we call

```
paste -d ' ' globus_batch_sources.txt globus_batch_destinations.txt
```

This horizontally concatenates the sources and destinations. Each line of globus_batch.txt looks like  
`/gridftp/ena/fastq/ERR459/ERR459206/ERR459206.fastq.gz /yeast-data/ERR459206.fastq.gz`

Finally, I initiated the very speedy transfer with  
`globus transfer $emblena: $nuquest: --batch globus_batch_list.txt --label "EMBL transfer" `

## Final Results

All download tests were done late at night way outside of working hours. The results are detailed in the table below.

| Method  | Time    |
| ------- | ------- |
| wget    |   24m   |
| fastq   |   73m   |
| fasterq |   53m   |
| ascp    |   12m   |
| globus  |    2m   |





