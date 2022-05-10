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
   * Check with `ifconfig` the result
#### You have to change the default port of the SSH service by the one of your choice. SSH access HAS TO be done with publickeys. SSH root access SHOULD NOT be allowed directly, but with a user who can be root.
   * Decomment and modify in `/etc/ssh/sshd_config`  `#Port 22` by your choice
   * restart the service `sudo /etc/init.d/ssh restart` 
   * try to connect `username@hostname -p <your port>`
   * Maybe you will have to change in your VM `setup/network/attached to` -> Bridged Adaptater

## Documentation:
* https://www.youtube.com/watch?v=ErzhbUusgdI
* https://linuxize.com/post/how-to-add-user-to-sudoers-in-debian/
* https://linuxconfig.org/how-to-setup-a-static-ip-address-on-debian-linux
* https://petri.com/how-30-and-32-bit-ip-subnet-masks-can-help-with-cisco-networking/
* https://www.linuxlookup.com/howto/change_default_ssh_port

  

