
This is the very first draft for making backups of mysql databases and drop them elsewhere.

#Requirements:

* dropbox  account
* mysql client
* pigz (you actually don't "need" it, replace with your favourite compressing utility)

#Usage
##Configure as nedded

Yeah, just edit the file. 

Of course, you must configure Dropbox-uploader 

##Create a cron job

Just drop a file in /etc/cron.d folder with this content to run the script at 3 am:

    00 3 * * * root /opt/backup/backup.sh

##Check your backups 

login into your dropbox account and be delighted with the view of your daily backups.

#To do

A bunch of stuff:

* allow external configuration file
* add a restore option
* add some options besides dropbox
* send a mail with the result


