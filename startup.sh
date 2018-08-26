#!/bin/bash
#
#1. test exec user
echo "perpare for setup: confirm setup user"
execuser=`whoami | echo`
if test "${execuser}" = "root"; then
    sudo su -
fi

#2. check internet connection access
echo "test internet connection access"
testip=`ip r | grep default | cut -d ' ' -f 3`
if test "${testip}" = ""; then
    echo "Please check network status"
    exit 9
fi

accessflg=`ping -q -w 1 -c 1 ${testip} > /dev/null && echo 0 || echo 9`
if test $accessflg -ne 0; then
    echo "Please check network status"
    exit 9
fi

#3. check firewall status
echo "check firewall status"
if [[ `firewall-cmd --state` = running ]]
then
    firewall_status=active
    systemctl stop firewalld
    systemctl disable firewalld
else
    firewall_status=inactive
fi
enfsts=`getenforce`
if test "${enfsts}" = "Enforcing";
then
   sed -i 's/enforcing/disabled/g' /etc/selinux/config /etc/selinux/config
fi

#5. server update
echo "Auto updating centos server........"
echo "setup 1: auto updating yum"
yum -y update

#6. add repository
yum -y install yum-plugin-priorities
sed -i -e "s/\]$/\]\npriority=1/g" /etc/yum.repos.d/CentOS-Base.repo
yum -y install epel-release
sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
yum -y install centos-release-scl-rh centos-release-scl
sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/CentOS-SCLo-scl.repo
sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

#7. install vim
yum -y install vim-enhanced
echo "alias vi='vim'" >> /etc/profile
source /etc/profile
echo "set history=500000" >> /etc/virc
echo "set ignorecase" >> /etc/virc
echo "set smartcase" >> /etc/virc
echo "set hlsearch" >> /etc/virc
echo "set incsearch" >> /etc/virc
echo "set number" >> /etc/virc
echo "set list" >> /etc/virc
echo "set showmatch" >> /etc/virc
echo "set binary noeol" >> /etc/virc
echo "set autoindent" >> /etc/virc
echo "syntax on" >> /etc/virc
echo "set highlight Comment ctermfg=LightCyan" >> /etc/virc

#8. install git
yum -y install git

#9. install ansible
yum -y install ansible
