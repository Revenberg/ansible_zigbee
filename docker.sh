#!/bin/bash
if [ ! -f "/home/pi/.pswrd" ]; then
    if [ $# -ne 1 ]; then
        echo $0: usage: $0  password
        exit 0
    fi     

    sudo apt-get update
    sudo apt-get autoremove

    sudo apt-get install git ansible sshpass 6tunnelBash -y
    sudo apt-get install docker-compose -y
    mkdir /home/pi/ansible
    git clone https://github.com/Revenberg/ansible_zigbee.git 

    echo $1 > /home/pi/.pswrd
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

echo "all:" > /home/pi/ansible/hosts
echo "  vars:" >> /home/pi/ansible/hosts
echo "    ansible_connection: ssh" >> /home/pi/ansible/hosts
echo "    ansible_ssh_user: pi" >> /home/pi/ansible/hosts
ansible-vault encrypt_string --vault-password-file /home/pi/.pswrd $pswrd --name '    ansible_ssh_pass'  >> /home/pi/ansible/hosts
echo "rpi:" >> /home/pi/ansible/hosts
echo "  hosts:" >> /home/pi/ansible/hosts


ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'  | head -n 1 | while read line;
do
  echo "    $line:" >> /home/pi/ansible/hosts
  echo "      ansible_user: pi" >> /home/pi/ansible/hosts
done

#echo /home/pi/ansible/hosts
#ansible-vault encrypt_string --vault-password-file /home/pi/.pswrd '$pswrd' --name ' ansible_ssh_pass'  >> /home/pi/ansible/hosts

cd /home/pi/ansible_zigbee
git pull
cd ~

cp /home/pi/ansible_zigbee/docker.sh /home/pi/docker.sh
chmod +x /home/pi/docker.sh

#ansible-playbook  /home/pi/ansible_zigbee/docker-install.yml --vault-password-file /home/pi/.pswrd -i /home/pi/ansible/hosts | tee ~/ansible.log
ansible-playbook  /home/pi/ansible_zigbee/docker.yml --vault-password-file /home/pi/.pswrd -i /home/pi/ansible/hosts | tee ~/ansible.log
