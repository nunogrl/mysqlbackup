#!/bin/sh 

BACKUPPATH="/opt/backup/"

prune ()
{
    [ REMOTE="0" ] && filename=$(basename $1) || filename=$1
    fileDate=$(echo $filename | cut -d_ -f 2)
    # todaymonth=$( date +%m )
    # todayyear=$( date +%Y )
    # MON=${1-$todaymonth}
    # YEA=${2-$todayyear}
    # A=(`echo $1 | sed -e 's/-/ /g'`)
    A=(`echo $fileDate | sed -e 's/-/ /g'`)

    YEA=${A[0]}
    MON=${A[1]}
    DAY=${A[2]}

firstmonday=`cal $MON $YEA |
awk '
NR == 1 { next }
NR == 2 { next }
NF <= 5 { next }
NF == 6 { print $1 ; exit }
NF == 7 { print $2 ; exit }
'`

oneweekago=$(date +%s --date="7 days ago")
B=$(date +%s --date="${YEA}-${MON}-${DAY}")
if [ $B -le $oneweekago ] ; then
    printf "date older that 1 week; " ;

    day=$(printf '%02s\n' "$firstmonday" | tr ' ' '0')
    if [ "$YEA-$MON-$DAY" == "$YEA-$MON-$day" ] ; then
        echo "is the first  monday";
    else 
        echo "not first monday: ";
                if [ "$REMOTE" = "0" ] ; then
                    echo "DELETE LOCAL:           $1"
            rm $1
                else
                    echo "DELETE REMOTE:           $1"
                    /opt/Dropbox-Uploader/dropbox_uploader.sh delete barbearclassico/$1
                fi
    fi
else
    echo "less than a week;"
fi 
}

REMOTE=0
for file in $(ls ${BACKUPPATH}bc*.sql.gz) ; do
    printf "$file :" ;
    prune $file;
done

echo "prune remote======================"
REMOTE=1
/opt/Dropbox-Uploader/dropbox_uploader.sh list barbearclassico |\
grep "sql.gz" | awk '{ print $3 }' | while read file ; do
    echo $file
    prune $file
done



exit 0


# Prunning logic
# keep 1 backup per day for the last week
# keep 1 backup per week for the last month
# keep 1 backup per month for everything else.
# ============================================
# Goal:
# 1 year =
#     11 backups (1 per month)
#     4  mondays current month
#     7  days current week
# ---------------------------
# TOTAL 22 backups / year

if  FileOlderThanOneMonth  -a  NotFirstMonday
    DeleteRemotefile
else
    if FileOlderThanOneWeek -a  NotMonday
        DeleteRemotefile
    fi
fi


