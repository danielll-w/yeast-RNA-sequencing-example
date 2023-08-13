#!/bin/bash
MYJOBID=$(sbatch yeast_SNF2_01.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_SNF2_22.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_SNF2_26.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_SNF2_31.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_SNF2_34.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_SNF2_43.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_WT_01.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_WT_31.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_WT_33.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_WT_37.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_WT_47.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
MYJOBID=$(sbatch --dependency=afterany:$MYJOBID yeast_WT_48.sh 2>&1 | grep -Eo '[0-9]+')
echo $MYJOBID
