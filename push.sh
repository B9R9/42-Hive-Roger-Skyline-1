#!/bin/bash

echo  "Do you want to push your changement to /var/www/mywebsite.com/index.html?[Y/n]"
read ANSWER

LOWER=$(echo $ANSWER | tr '[:upper:]' '[:lower:]')

#WAY="/home/marty/index.html"
if [ $LOWER  = 'y' ] || [ $LOWER = 'yes' ]; then
	#Create back up file
    if [ ! -e "/var/www/mywebsite.com/index_backup.html" ];then
       sudo cp /var/www/mywebsite.com/index.html /var/www/mywebsite.com/index.backup
    fi
    echo -e "Enter PATH of file: "
    read WAY
    DIFF=$(diff $WAY /var/www/mywebsite.com/index.html)
    if [ "$DIFF" = "" ];then
	    echo -e "There is no changment to push"
	    exit 1
    else
    	sudo cp $WAY /var/www/mywebsite.com/index.html
    fi
    if [ -e "/var/www/mywebsite.com/index.html" ];then
        echo -e "Your changment has been push to /var/www/mywebsite.com/"
        exit 1
    else
	echo -e "Your changment are not effective"
	exit 1
    fi
else
	echo -e "Your changment are not effective"
	exit 1
fi