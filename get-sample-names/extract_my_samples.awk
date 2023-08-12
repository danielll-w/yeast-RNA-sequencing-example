BEGIN { FS="\t" }
      { errnum=$1
        techrep=$2
        type=$3
        biorep=$4
        if ((type=="WT")&&((biorep==1)||(biorep==31)||(biorep==33)||(biorep==37)||(biorep==47)||(biorep==48))) { print }
        if ((type=="SNF2")&&((biorep==1)||(biorep==22)||(biorep==26)||(biorep==31)||(biorep==34)||(biorep==43))) { print }
      }
