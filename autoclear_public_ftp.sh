#!/bin/bash -
#title          :autoclear_public_ftp.sh
#description    :A script to automaticly delete old files from a public ftp
#                directory
#author         :gliech
#date           :20130422
#version        :1.0
#usage          :./autoclear_public_ftp.sh
#notes          :The script is build for use as cronjob, an interval of 1 or 2
#                hours is recommended. TTL is the time until deletion after the
#                last modification in seconds
#bash_version   :4.2.25(1)-release
#============================================================================

WORKING_DIR=/path/to/ftp/publicfolder
FILES=$WORKING_DIR/*
EXCEPTION=/path/to/ftp/publicfolder/static
TTL=172800

CURRENT_TIME=$(date +%s)
COUNTER=0

date 
echo

for f in $FILES
do
	if [[ "$f" != $EXCEPTION ]]
	then
		MOD_TIME=$(stat -c %Y "$f")
		if [[ $CURRENT_TIME > $(( $MOD_TIME + $TTL )) ]]
		then
			rm -rf "$f" 2>/dev/null
			if [[ $? == 0 ]]
			then
				echo -e "$f was deleted because it was $(( $CURRENT_TIME - $MOD_TIME ))s old $(( $CURRENT_TIME - $MOD_TIME - $TTL ))s over the ttl"
				COUNTER=$(( $COUNTER + 1 ))	
			else
				stat --printf='Error: %n   Type: %F   U: %U   G: %G   %A   Size: %s byte   Last Modification: %y   could not be deleted.\n' "$f"
			fi
		fi
	fi
done
echo -e "\nScan finished. $COUNTER files and/or directories have been removed from $WORKING_DIR.\n\n"
