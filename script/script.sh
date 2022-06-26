#!/bin/bash

# Author: Artak Abrahamyan
# Data created: 22/06/22
# Last modified : 26.06.22

# Description
# 1. Change SSH default port to 2234
# 2. Add rule that block all requests to all ports except web servers from external IPs (not DHCP range)
# 3. Backup home folder NGINX 4 times a day, mysql once per hour and should keep backups for last 10 days

# Usage
# script.sh

sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install mysql-server -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install php8.1-fpm php-mysql -y

sudo chown -R $USER:$USER /var/www
sudo chown -R $USER:$USER /etc/nginx/
sudo cat ~/index.php > /var/www/html/index.php
sudo cat ~/default > /etc/nginx/sites-available/default
sudo cat ~/nginx.conf > /etc/nginx/nginx.conf


# 1

# sudo echo "Port 2234" >> /etc/ssh/sshd_config
# sudo systemctl restart sshd


#2

sudo apt-get iptables-persistent -y
sudo netfilter-persistent save
# Allow login via SSH
sudo iptables -A INPUT -i eth0 -p tcp --dport 2234 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p tcp --sport 2234 -m state --state ESTABLISHED -j ACCEPT
# Allow HTTP traffic
sudo iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
# Allow HTTPS traffic
sudo iptables -A INPUT -i eth0 -p tcp --dport 443-m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -o eth0 -p tcp --sport 443-m state --state ESTABLISHED -j ACCEPT


# 3
sudo mkdir /var/nginx_backups
sudo touch /etc/crontab && chmod 644 /etc/crontab
sudo echo "0 */6 * * *  tar -zcf FILES-backup/"$(date '+\%m-\%d-\%y').tar.gz" /var/www/html/" >> /etc/crontab
