#!/bin/bash
printf "\e[0;33m          ----------------------- \n" >> /var/log/sys_update.log
printf "\e[0;33m         |***  \e[1;33mUPDATE SYSTEM\e[0;33m  ***|\n" >> /var/log/sys_update.log
printf "\e[0;33m          ----------------------- \e[0m\n" >> /var/log/sys_update.log
printf "" >> /var/log/sys_update.log
printf "\e[1;36mStarted: \e[0m" >> /var/log/sys_update.log
date >> /var/log/sys_update.log
printf "\n" >> /var/log/sys_update.log
printf "\e[4;33mUPDATE:\e[0m\n" >> /var/log/sys_update.log
sudo apt-get update -y >> /var/log/sys_update.log
printf "\n" >> /var/log/sys_update.log
printf "\e[4;33mUPGRADE:\e[0m\n" >> /var/log/sys_update.log
sudo apt-get full-upgrade -y >> /var/log/sys_update.log
printf "\n" >> /var/log/sys_update.log
printf "\e[4;33mAUTOREMOVE\e[0m\n" >> /var/log/sys_update.log
sudo apt-get autoremove >> /var/log/sys_update.log
printf "\n" >> /var/log/sys_update.log
printf "\e[4;33mAUTOCLEAN:\e[0m\n" >> /var/log/sys_update.log
sudo apt-get autoclean >> /var/log/sys_update.log
printf "\n"  >> /var/log/sys_update.log
printf "\e[1;36mEnded: \e[0m" >> /var/log/sys_update.log
date >> /var/log/sys_update.log
printf "\n" >> /var/log/sys_update.log
echo -e "\e[0;32m-----------------------------------\e[0m" >> /var/log/sys_update.log
echo "" >> /var/log/sys_update.log