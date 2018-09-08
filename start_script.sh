#!/bin/bash
# Author: ben187

HOSTNAME=centos

SECURE_SSHD=y
SSHD_PORT=22
SSHD_USERS='root'
SSHD_ROOT_LOGIN=y

CONFIG_DNS=y
CONFIG_IPFORWARD=y
CONFIG_IPTABLES=y
CONFIG_SELINUX=y

INSTALL_HTOP=y
INSTALL_NMAP=y
INSTALL_NETUTILS=y
INSTALL_WGET=y
INSTALL_GIT=y
INSTALL_MAN_PAGES=y
INSTALL_SCREEN=y
REBOOT=y

hostname $HOSTNAME
yum install -y epel-release
yum -y update

### SSH ##########
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

### DNS ##########
if [[ "$CONFIG_DNS" = [yY] ]] ; then
        echo "nameserver 8.8.4.4
nameserver 8.8.8.8"> /etc/resolv.conf
        fi

### IP FORWARD ###
if [[ "$CONFIG_IPFORWARD" = [yY] ]] ; then
        echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf 
        fi
### IPTABLES #####
if [[ "$CONFIG_IPTABLES" = [yY] ]] ; then
        systemctl stop firewalld
        systemctl disable firewalld
        yum -y install iptables-services
        systemctl enable iptables.service
        systemctl start iptables.service
        > /etc/sysconfig/iptables
        cat >> /etc/sysconfig/iptables <<EOF
*filter
:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT

-A INPUT -i lo -j ACCEPT

-A INPUT -m conntrack --ctstate INVALID -j DROP
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

-A INPUT -p tcp -m state --state NEW -m tcp --dport $SSHD_PORT -j ACCEPT

COMMIT
EOF
        fi

### SELINUX #####
if [[ "$CONFIG_SELINUX" = [yY] ]] ; then
        sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
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
if [[ "$INSTALL_SCREEN" = [yY] ]] ; then
        yum -y install screen
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
