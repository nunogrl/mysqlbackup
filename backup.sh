#!/bin/bash

CONFIGFILE=/opt/backup/backup.ini
BACKUP=/opt/backup/

function ini_get
{
    eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
        -e 's/;.*$//' \
        -e 's/[[:space:]]*$//' \
        -e 's/^[[:space:]]*//' \
        -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
    < $CONFIGFILE \
    | sed -n -e "/^\[$1\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`

    echo ${!2}
}

# if there's no file, quits
[ ! -f $CONFIGFILE ] && exit 0;

# Get information from file
file=$(ini_get MYSQLBACKUP file)
dbserver=$(ini_get MYSQLBACKUP dbserver)
user=$(ini_get MYSQLBACKUP user)
pass=$(ini_get MYSQLBACKUP pass)
database=$(ini_get MYSQLBACKUP database)
remotefolder=$(ini_get MYSQLBACKUP remotefolder)


mysqldump --opt --user=${user} --password=${pass} ${database} | /usr/bin/pigz  >  ${BACKUP}${file}

# Upload file
(cd ${BACKUP} && . ./Dropbox-Uploader/dropbox_uploader.sh -q upload ${file} ${remotefolder} )


# If sucessfuly uploaded; remove local copy 
${BACKUP}/Dropbox-Uploader/dropbox_uploader.sh list  {$remotefolder}  | /bin/grep -q  ${file} && rm  ${BACKUP}${file}


