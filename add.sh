#!/bin/bash
cd /home/pi/ansible_zigbee
git pull
cd ~

cp /home/pi/ansible_zigbee/add.sh /home/pi/add.sh
chmod +x ~/add.sh

ansible-playbook  /home/pi/ansible_zigbee/add.yml --vault-password-file /home/pi/.pswrd -i /home/pi/ansible/hosts 
