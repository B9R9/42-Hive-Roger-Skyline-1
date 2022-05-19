# Roger Skyline

## Introduction
  This subject follows Init where you have learn some of basics commands and first reflexes in system and network administration. This one will be a concrete exemple of the use of those commands and will let you start your own first web server. This is why we’ve decided to offer you three subjects and not two (Surprise!)
• Initiation subject (Init).
• A subject about VM creation (Roger-Skyline-1).
• A subject about the creation of a full infrastructure (Roger-Skyline-2).

## Objectives
  This second project, roger-skyline-1 let you install a Virtual Machine, discover the basics about system and network administration as well as a lots of services used on a server machine.
  
### VM INSTALLATION

### Network and Security Part
#### You must create a non-root user to connect to the machine and work.
   * `su`    then    `addsuser <username>`
#### Use sudo, with this user, to be able to perform operation requiring special rights.
   * sudo installation:
          * `su`    then    `apt-get install sudo`
   * add user to sudo group:
        * `su`    then    `usermod -aG sudo <username>`
        *  You can check if user has been added to the sudo group with the commmand  `sudo whoami`
        *  Add `username  ALL=(ALL) NOPASSWD:ALL` to the `/etc/sudoers` file
#### We don’t want you to use the DHCP service of your machine. You’ve got to configure it to have a static IP and a Netmask in \30.
   * net-tools installation
````
      sudo apt-get insatll net-tools
````
   * Create  `enp0s3`  in `/etc/network/interface.d` and copy this:
````
iface enp0s3 inet static
      address <Static ip adress>
      netmask 255.255.255.252
      gateway <route -n get default | grep gateway> to find your gateway address(in MC terminal)
````
   * Modify `/etc/network/interface` by replacing by `auto enp0s3` the Primary network interfaces 
   * restart the service 
 ````
  sudo service networking restart
 ````
   * Check with `ifconfig` the result and try `ping google.com`
   * Maybe you will have to change in your VM `setup/network/attached to` -> Bridged Adaptater
#### You have to change the default port of the SSH service by the one of your choice. SSH access HAS TO be done with publickeys. SSH root access SHOULD NOT be allowed directly, but with a user who can be root.
   * Uncomment and modify in `/etc/ssh/sshd_config`  `#Port 22` by your choice
   * restart the service `sudo /etc/init.d/ssh restart` 
   * try to connect `username@hostname -p <your port>`
   * Create a new ssh-key or use the one already existed (from MC terminal)
````
ssh-copy-id -i ~/.ssh/id_rsa.pub username@hostname -p <port>
````
   * try to connect `username@hostname -p <your port>` from MC terminal
   * Uncomment and change `PasswordAuthentification` to `no` the file `/etc/ssh/sshd_config` (from VM)

####  You have to set the rules of your firewall on your server only with the services used outside the VM
   *  You can try [iptables](https://linux.die.net/man/8/iptables)
```
sudo apt-get install iptables
```
   * Or the easy way is [ufw](line vers ufw)
```
sudo apt install ufw
sudo ufw status
sudo ufw enable
```
   * Allow the ssh concection
```
sudo ufw allow <port>/tcp
```
   * Allow HTTPS
```
sudo ufw allow 443/tcp
```
   * Allow HTTP
```
sudo ufw allow 80/tcp
```
   * To deny all incomming connection and allow all outgoing connection by default
```
sudo ufw default deny incoming
sudo ufw default allow outgoing
```
   * Restart the service
   * Check the result with `sudo ufw status`
   * Some useful command
```
sudo ufw status
sudo ufw enable
sudo ufw verbose
```

####  You have to set a DOS (Denial Of Service Attack) protection on your open ports of your VM.
   * Install [fail2ban](lien ver sfails 2ban man)
```
sudo apt install fail2ban
```
   * Make a copy of `jail.conf` to `jail.local`
```
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```
   * Create a jail for DOS attack
```
[http-get-dos]
                            
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/apache2/access.log
maxentry = 300
findtime = 300
bantime = 600
action = iptables[name=HTTP, port=http, protocol=tcp]
```
   * Set rules for SSHD jail
```
[sshd]
#To use more aggressive sshd modes set filter parameter "mode" in jail.local:
#normal (default), ddos, extra or aggressive (combines all).
#See "tests/files/logs/sshd" or "filter.d/sshd.conf" for usage example and details.
mode   = agressive
enabled = true
port    = <yourport>;
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxentry = 3
bantime = 600
```
   * Create `/etc/fail2ban/filter.d/http-get-dos.conf`
   * Copy
```
[Definition]

failregex = ^<HOST> -.*GET
ignoreregex =
```
   * Test your filter with
```
sudo fail2ban-regex /var/log/apache2/access.log /etc/fail2ban/filter.d/http-get-dos.conf
```
   * You can use [slowloris](lien vers github) to test DOS attack
   * If you need to unbann you (and you will need)
```
sudo fail2ban-client set jail_name unbanip xxx.xxx.xxx.xxx
```

 #### You have to set a protection against scans on your VM’s open ports.
  * Install nmap to scan port from MC terminal
```
sudo apt install nmap
```
  * Scan server
```
nmap -PN -sS <IP ADDRESS>
```
  * To protect you from scan port, Install [portsentry](https://man.cx/portsentry(8))
```
sudo apt-get install portsentry
```
   * Edit `/etc/default/portsentry` and change
```
TCP_MODE="tcp"
UDP_MODE="udp"
```
for
```
TCP_MODE="atcp"
UDP_MODE="audp"
```
   * Uncomment the line `KILL_ROUTE="/sbin/iptbales -I INPUT -s $TARGET$ -j DROP"`
   * Run `nmap 10.**.***.***`, You should get you ban.
   * Check the banned IPS `sudo iptables -L -n -v | head`
   * To unbanned your self `sudo iptables -D INPUT -s 10.**.***.** -j DROP`
   * And remove your IP address from `/etc/hosts.deny`

#### Stop the services you don’t need for this project.
   * To list all the enabled service
```
sudo systemctl list-unit-files --type=service --state=enabled --all
```
   *  To disabled a service use
```
sudo systemctl disable [service name]
```
   * Here the list of service needed
```
apache2
cron 
fail2ban 
getty 
networking 
ssh 
ufw
```
#### Create a script that updates all the sources of package, then your packages and which logs the whole in a file named /var/log/update_script.log. Create a scheduled task for this script once a week at 4AM and every time the machine reboots.
   * Here is my script:
```c
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
```
   * To use [crontab](lien vers crontab man)
```
crontab -e #to edit
crontab -l #to list 
```
   * After use `crontab -e` add this line
```
@reboot /path/of/your/file &
0 4 * * MON /path/of/your/file &
```
#### Create a script that updates all the sources of package, then your packages and which logs the whole in a file named /var/log/update_script.log. Create a scheduled task for this script once a week at 4AM and every time the machine reboots.

   * My script:
```
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
```
   * Add it to the crontab by adding `0 0 * * * /PATH/OF/THE/FILE &`
   * To configure your system to handles emails, install
```
sudo apt install mailutils postfix
```
   * During the installation choose local only and system mail name to debian.lan
   * Edit `/etc/aliases` and change the line by `root : root@debian.lan`
   * Then run `sudo newaliases`
   * To check your mail, use `mailx`
   * `sudo tail -f /var/log/mail.log` can be useful

### WEB PART

   If you didn't install [apache2](https://medium.com/swlh/apache-for-beginners-9d104225ec89), install it
```
sudo apt install apache2
```
You can create your web site in `/var/www/yourdirectorie`
Create your index.html in your directorie.
Then create `sudo vim /etc/apache2/sites-available/mysite.com.conf`
Inside copy the default configuration file located at `/etc/apache2/sites-available/000-default.conf`
the content to copy:
```
<VirtualHost *:80>
    ServerAdmin admin@mysite.com
    ServerName mysite.com
    DocumentRoot /var/www/mysite.com
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Enable by running `sudo a2ensite mysite.com.conf`
Final  check:
```
sudo apache2ctl configtest
sudo systemctl reload apache2
```
You have to set a self-signed SSL on all of your services.
```
sudo a2enmod ssl
sudo systemctl restart apache2
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
```
Then create `/etc/apache2/sites-available/10.1x.xxx.xxx.conf`
And copy
```
<VirtualHost *:443>
	ServerName 10.**.***.***
	DocumentRoot /var/www/html/

	SSLEngine on
	SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
	SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
<VirtualHost *:80>
	ServerName 10.**.***.***
	Redirect / https://10.**.***.***/
</VirtualHost>
```
Test your config `sudo apache2ctl configtest`. The return should be something like this:
```
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
```
You can run `sudo a2ensite 10.1x.xxx.xxx` and `sudo systemctl reload apache2`


## Documentation:
* https://www.youtube.com/watch?v=ErzhbUusgdI
* https://linuxize.com/post/how-to-add-user-to-sudoers-in-debian/
* https://linuxconfig.org/how-to-setup-a-static-ip-address-on-debian-linux
* https://petri.com/how-30-and-32-bit-ip-subnet-masks-can-help-with-cisco-networking/
* https://www.linuxlookup.com/howto/change_default_ssh_port
* https://www.hostinger.fr/tutoriels/iptables
* http://www.delafond.org/traducmanfr/man/man8/iptables.8.html
* https://www.ionos.fr/digitalguide/serveur/outils/tutoriel-iptables-des-regles-pour-les-paquets-de-donnees/
* https://www.netfilter.org/documentation/index.html#documentation-howto
* https://help.ubuntu.com/community/UFW
* https://www.digitalocean.com/community/tutorials/how-to-protect-an-apache-server-with-fail2ban-on-ubuntu-14-04
* https://bobcares.com/blog/centos-ddos-protection/
* https://www.tothenew.com/blog/fail2ban-port-80-to-protect-sites-from-dos-attacks/

  

