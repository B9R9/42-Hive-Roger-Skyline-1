#!bin/bash
if [ ! -e "/etc/crontab.backup" ];then
	printf "No backup file found\n"
	printf "Creation of crontab.backup\n"
	cp /etc/crontab  /etc/crontab.backup
	exit 0
else
	DIFF=$(diff /etc/crontab /etc/crontab.backup)
	if [ "$DIFF" != "" ]; then
		printf "Your crontab has been changed\n" | mail -s 'Crontab change' root@debian.lan
		cp /etc/crontab /etc/crontab.backup
		exit 0
fi