#!/bin/bash

FILE=bc_`date +"%F_%H-%M"`.sql.gz
DBSERVER=127.0.0.1
DATABASE=databasename
USER=databaseuser
PASS=databasepass
BACKUP=/opt/backup/


mysqldump --opt --user=${USER} --password=${PASS} ${DATABASE} | /usr/bin/pigz  >  ${BACKUP}${FILE}
# wait
(cd ${BACKUP} && . ../Dropbox-Uploader/dropbox_uploader.sh -q upload ${FILE} barbearclassico )

/opt/Dropbox-Uploader/dropbox_uploader.sh list  barbearclassico   | /bin/grep -q  ${FILE} && rm  ${BACKUP}${FILE}


