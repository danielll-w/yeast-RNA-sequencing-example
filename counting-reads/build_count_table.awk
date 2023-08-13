BEGIN { filecount=0  
        maxrows=0
}
{ filename = $1   # get next file
  filecount=filecount+1
  filenamevec[filecount]=filename  # save file name
  n = split(filename,nameparts,"_")  # split on "_" 
  # make string type_rep, e.g., WT_01
  type_rep=sprintf("%s_%s",nameparts[2],nameparts[3])
  typerepvec[filecount]=type_rep  # save type_rep string
  # skip 4 header lines
  getline < filename
  getline < filename
  getline < filename
  getline < filename
  rowcount=0;   # now loop through genes
  while ((getline < filename) > 0) {
     rowcount=rowcount+1
     geneid=$1       # geneid
     genecount=$2    # counts
     # save geneid by row number
     geneidvec[rowcount]=geneid
     # save counts by geneid and file #
     readcounts[geneid,filecount]=genecount
     if (rowcount>maxrows) {
         maxrows=rowcount  # keep track of maxrows
     }
  }
}
      # write final output table 
END { # write header line first
      printf "\t"
      for (i=1;i<filecount;i++) {
          printf "%s\t", typerepvec[i]
      }
      printf "%s\n", typerepvec[filecount]
      # now loop through genes (rows)
      for (row=1;row<=maxrows;row++) {
          geneid=geneidvec[row]  # print geneid
          printf "%s\t",geneid
          # loop through columns (counts)
          for (col=1;col<filecount;col++) {
              printf "%i\t",readcounts[geneid,col]
          }
          # don't need tab after last one
          printf "%i\n",readcounts[geneid,filecount]
      }
}
