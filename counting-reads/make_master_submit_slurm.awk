BEGIN { print "#!/bin/bash" }
NR == 1 { print "MYJOBID=$(sbatch " $1 " 2>&1 | grep -Eo '[0-9]+')" 
          print "echo $MYJOBID"
         }
NR > 1  { print "MYJOBID=$(sbatch --dependency=afterany:$MYJOBID " $1 " 2>&1 | grep -Eo '[0-9]+')" 
          print "echo $MYJOBID"
        }
        
