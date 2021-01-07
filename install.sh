#!/bin/bash
if [ ! -f "/home/pi/.pswrd" ]; then
    if [ $# -ne 1 ]; then
        echo $0: usage: ./install.sh  password
        exit 0
    fi

    echo $1 > /home/pi/.pswrd

    sudo apt-get update
    sudo apt-get autoremove

    sudo apt-get install git -y

    # Install Ansible and Git on the machine.
    sudo apt-get install python-pip git python-dev sshpass -y
    sudo pip install ansible
    sudo pip install markupsafe

    # Configure IP address in "hosts" file. If you have more than one
    # Raspberry Pi, add more lines and enter details

    mkdir /home/pi/ansible

    git clone https://github.com/Revenberg/ansible_zigbee.git 

    ansible-playbook --connection=local /home/pi/ansible_zigbee/changepassword.yml
fi

mkdir /home/pi/.ssh 2>/dev/null

sudo ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key
sudo ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key
ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'  | while read line;
do
    ssh-keyscan -H $line >> ~/.ssh/known_hosts
done
sudo ssh-keygen -l -f /etc/ssh/ssh_host_rsa_key

pswrd=$(cat /home/pi/.pswrd)

echo "" > /home/pi/ansible/hosts
echo "ansible_connection=ssh" >> /home/pi/ansible/hosts
echo "ansible_ssh_user=pi" >> /home/pi/ansible/hosts
echo "ansible_ssh_pass="$(ansible-vault encrypt_string --vault-password-file /home/pi/.pswrd $pswrd --name '')  >> /home/pi/ansible/hosts
echo "" >> /home/pi/ansible/hosts
echo "[rpi]" >> /home/pi/ansible/hosts

ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'  | head -n 1 | while read line;
do
  echo "home ansible_host=$line ansible_connection=ssh ansible_user=pi" >> /home/pi/ansible/hosts
done

cd /home/pi/ansible_zigbee
git pull
cd ~

cp /home/pi/ansible_zigbee/install.sh /home/pi/install.sh
chmod +x ~/install.sh
cp /home/pi/ansible_zigbee/add.sh /home/pi/add.sh
chmod +x ~/add.sh

ansible-playbook  /home/pi/ansible_zigbee/zigbee.yml --vault-password-file /home/pi/.pswrd -i /home/pi/ansible/hosts 
