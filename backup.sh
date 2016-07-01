#!/bin/bash

FILE=bc_`date +"%F_%H-%M"`.sql.gz
DBSERVER=127.0.0.1
DATABASE=databasename
USER=databaseuser
PASS=databasepass
BACKUP=/opt/backup/
REMOTEFOLDER=remotefolder


mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} | /usr/bin/pigz  >  ${BACKUP}${FILE}

# Upload file
(cd ${BACKUP} && . ./Dropbox-Uploader/dropbox_uploader.sh -q upload ${FILE} ${REMOTEFOLDER} )


# If sucessfuly uploaded; remove local copy 
${BACKUP}/Dropbox-Uploader/dropbox_uploader.sh list  {$REMOTEFOLDER}   | /bin/grep -q  ${FILE} && rm  ${BACKUP}${FILE}


