#!/bin/bash
# Author: ben187

SECURE_SSHD=y
SSHD_PORT=10022
SSHD_USERS='root'
SSHD_ROOT_LOGIN=y

CONFIG_DNS=y
CONFIG_IPTABLES=y
CONFIG_IPFORWARD=y
CONFIG_BASHRC=y

INSTALL_HTOP=y
INSTALL_NMAP=y
INSTALL_NETUTILS=y
INSTALL_WGET=y
INSTALL_GIT=y
INSTALL_MAN_PAGES=y
REBOOT=y

yum install -y epel-release
yum -y update

if [[ "$SECURE_SSHD" = [yY] ]]; then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
        cat >> /etc/ssh/sshd_config <<EOF

Port $SSHD_PORT
AllowUsers $SSHD_USERS
EOF
fi

if [[ "$SSHD_ROOT_LOGIN" = [nN] ]]; then
        sed -i 's/PermitRootLogin yes/#PermitRootLogin yes/' /etc/ssh/sshd_config
        fi

if [[ "$CONFIG_DNS" = [yY] ]] ; then
        echo "nameserver 8.8.4.4
nameserver 8.8.8.8"> /etc/resolv.conf
        fi

if [[ "$CONFIG_IPFORWARD" = [yY] ]] ; then
        sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf
        fi

if [[ "$CONFIG_IPTABLES" = [yY] ]] ; then
        > /etc/sysconfig/iptables
        cat /iptables > /etc/sysconfig/iptables
        fi
if [[ "$CONFIG_BASHRC" = [yY] ]]; then
        cp /root/.bashrc /root/.bashrc.backup
        cat >> /root/.bashrc <<EOF

PS1='\[\e[1;30m\]\t \e[m\]\e[1;34m[\u@\h]\e[m\] \[\e[1;97m\]\W\e[m\] \n\$ '
EOF
fi
if [[ "$INSTALL_HTOP" = [yY] ]] ; then
        yum -y install htop
        fi

if [[ "$INSTALL_NMAP" = [yY] ]] ; then
        yum -y install nmap
        fi

if [[ "$NET_TOOLS" = [yY] ]] ; then
        yum -y install net-tools
        fi

if [[ "$INSTALL_WGET" = [yY] ]] ; then
        yum -y install wget
        fi
if [[ "$INSTALL_GIT" = [yY] ]] ; then
        yum -y install git
        fi
if [[ "$INSTALL_MAN_PAGES" = [yY] ]] ; then
        yum -y install man
        fi        

if [[ "$SECURE_SSHD" = [yY] ]]; then
        service sshd restart
fi

if [[ "$CONFIG_IPTABLES" = [yY] ]]; then
        service iptables restart
        fi
 
if [[ "$REBOOT" = [yY] ]] ; then
        shutdown -r now
        fi
