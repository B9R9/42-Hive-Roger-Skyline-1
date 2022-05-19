#!/bin/bash

createVM (){

VBoxManage createvm --name $NAME --ostype "Debian_64" --register --basefolder "/Users/briffard/goinfre/"
VBoxManage modifyvm $NAME --memory 1024
VBoxManage modifyvm $NAME --vram 64
#VBoxManage modifyvm $NAME --bridgeadapter1 vmnet1
#VBoxManage modifyvm $NAME --nic1 bridged
VBoxManage createhd --filename /Users/briffard/goinfre/$NAME.vdi --size 8000 -variant VDI
VBoxManage storagectl $NAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $NAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /Users/briffard/goinfre/$NAME.vdi
VBoxManage storagectl $NAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $NAME --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "./debian.iso/debian-11.3.0-amd64-netinst.iso"
VBoxManage modifyvm $NAME --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm debian --vrde on
#VBoxManage unattended install $NAME --iso /Users/briffard/Downloads/debian-11.3.0-amd64-netinst.iso  --user=mak --full-user-name="Joe_Dassin" --password 155589  --install-additions --time-zone=UTC
}

if [ $1 = 'turnoff' ];then
	VBoxManage controlvm $2 poweroff
	exit 1
fi
if [ $1 = 'run' ];then
	ret=$(VBoxManage list -s runningvms | grep $2)
	if [ -z "$ret" ]; then
		VBoxMAnage startvm $2
	fi
	if [ $2 = 'Roger3' ]; then
		ssh non-root@10.11.222.224 -p 50000
		exit 1
	fi
	if [ $2 = 'test9' ];then
		ssh boby_la_pointe@10.11.222.225 -p 52000
	exit 1
	fi
fi
if [ $1 = 'create' ]; then
	echo -e "Please insert the name of the Virtual Machine ?"
	read NAME
	createVM
	exit 1
fi