#!bin/sh

latest=$(/opt/bctools/dropbox_uploader.sh list barbearclassico | tail -n1 | cut -d' ' -f4)

echo $latest 
mkdir -p /opt/income
/opt/bctools/dropbox_uploader.sh download barbearclassico/$latest /opt/income/.
