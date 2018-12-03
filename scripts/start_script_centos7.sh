#!/bin/bash
# Author: ben187

#CONFIG_IPFORWARD=y
#CONFIG_SELINUX=y
#CONFIG_BASHRC=y

#INSTALL_IPTABLES=y
#INSTALL_UTILS=y

#REBOOT=y

echo "Wellcome to start config script for Centos7. Please wait..."
yum install -y epel-release &> /dev/null

echo "Enable ip forward, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		CONFIG_IPFORWARD=y
	else	
        echo "Config ipforward cancelled"
	fi
	
if [[ "$CONFIG_IPFORWARD" = [yY] ]] ; 
then
	if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf;
	then	
		sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf
	else
		echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
	fi
fi
echo "Disable SELinix, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		CONFIG_SELINUX=y
	else	
        echo "Disable SELinix cancelled"
	fi
	
if [[ "$CONFIG_SELINUX" = [yY] ]] ; 
then
	if grep -q "SELINUX=enforcing" /etc/selinux/config;
	then	
		sed -i 's/SELINUX=enforcing/SELINUX=disables/' /etc/selinux/config
	else
		echo "SELINUX=disables" >> /etc/selinux/config
		fi
	fi
echo "Install iptables, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		INSTALL_IPTABLES=y
	else	
        echo "Install iptables cancelled"
	fi
	
if [[ "$INSTALL_IPTABLES" = [yY] ]] ;
then
	systemctl stop firewalld &> /dev/null
	systemctl disable firewalld &> /dev/null
	yum -y install iptables-services &> /dev/null
	systemctl enable iptables.service &> /dev/null
	systemctl restart iptables.service &> /dev/null
  	fi

echo "Config simple iptables rules, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		CONFIG_IPTABLES=y
	else	
        echo "Config iptables cancelled"
	fi

if [[ "$CONFIG_IPTABLES" = [yY] ]];
then
	cp /etc/sysconfig/iptables /etc/sysconfig/iptables.backup
	cat > /etc/sysconfig/iptables <<EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
#-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF
	systemctl restart iptables.service &> /dev/null
	fi

echo "Config bashrc, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		CONFIG_BASHRC=y
	else	
        echo "Config bashrc cancelled"
	fi

if [[ "$CONFIG_BASHRC" = [yY] ]];
then
	cp /root/.bashrc /root/.bashrc.backup
	cat >> /root/.bashrc <<EOF
PS1="\[$(tput bold)\]\[$(tput setaf 4)\]\t\[$(tput setaf 7)\][\[$(tput setaf 7)\]@\[$(tput setaf 3)\]\h \[$(tput setaf 7)\]\W\[$(tput setaf 7)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
EOF
	fi

echo "Install utils and programms, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		INSTALL_UTILS=y
	else	
        echo "Install utils cancelled"
	fi

if [[ "$INSTALL_UTILS" = [yY] ]] ;
then
	yum -y install htop nmap net-tools wget bind-utils tree &> /dev/null
	fi

echo "Yum update, please wait..."
yum update -y &> /dev/null

echo "Reboot system now, are you sure?"
    read REPLY
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		REBOOT=y
		echo "Script completed successfully, system sent to reboot" 
	else	
        echo "Script completed successfully"
	fi 
