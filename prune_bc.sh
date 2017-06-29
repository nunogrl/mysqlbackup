#!/bin/sh 

# Prunning logic
# keep 1 backup per day for the last week
# keep 1 backup per week for the last month
# keep 1 backup per month for everything else.
# ============================================
# Goal:  
# 1 year = 
# 	11 backups (1 per month) 
# 	4  mondays current month
# 	7  days current week
# ---------------------------
# TOTAL 22 backups / year

# if  FileOlderThanOneMonth  -a  NotFirstMonday 
# 	DeleteRemotefile
# else 
# 	if FileOlderThanOneWeek -a  NotMonday
# 		DeleteRemotefile
# 	fi
# fi


prune ()
{
	fileDate=$(echo $1 | cut -d_ -f 2) 
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
		echo "not first monday";
		rm $1  
	fi
else
	echo "less than a week;"
fi 
}

for file in $(ls bc*.sql.gz) ; do
	printf "$file :" ; 
	prune $file;
done



exit 0



