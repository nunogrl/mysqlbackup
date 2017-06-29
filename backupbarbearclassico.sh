#!/bin/bash


FILE=bc_`date +"%F_%H-%M"`.sql.gz
DBSERVER=127.0.0.1
DATABASE=database
USER=username
PASS=password
BACKUP=/opt/backup/

TODAY=$(date +%F)


mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} | /usr/bin/pigz  >  ${BACKUP}${FILE} 
# wait 
echo "(cd ${BACKUP} && . ../Dropbox-Uploader/dropbox_uploader.sh -q upload ${FILE} barbearclassico )"

echo "/opt/Dropbox-Uploader/dropbox_uploader.sh list  barbearclassico   | /bin/grep -q  ${FILE} && rm  ${BACKUP}${FILE}"

exit 0 


/opt/Dropbox-Uploader/dropbox_uploader.sh list  barbearclassico  | grep sql.gz | while read line ; do 
	echo $line ; 
	filename=`echo $line | awk '{ print $3 }'` ; 
	printf "$filename "; 
	filedate=`echo $line | awk -F"_" '{ print $2 }'` ; 
	printf "$filedate "  ; 
	dow=$(date -d $filedate +%u) ; 
	echo $dow ; 
done


