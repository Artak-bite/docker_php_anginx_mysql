#!bin/bash

sudo netfilter-persistent save


# Allow login via SSH

iptables -A INPUT -i eth0 -p tcp --dport 2234 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 2234 -m state --state ESTABLISHED -j ACCEPT


# Allow HTTP traffic

iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT


# Allow HTTPS traffic

iptables -A INPUT -i eth0 -p tcp --dport 443-m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443-m state --state ESTABLISHED -j ACCEPT
