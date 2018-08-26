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
testip=`ip r | grep default | cut -d ' ' -f 3 | echo`
if test "${testip}" != ""; then
    echo "Please check network status"
    exit 9
fi

accessflg=`ping -q -w 1 -c 1 ${testip} > /dev/null && echo 0 || echo 9`
if test $accessflg -ne 0; then
    echo "Please check network status"
    exit 9
fi

#3. check firewall status
echo "test internet connection access"

#4. server update
echo "Auto updating centos server........"
echo "setup 1: auto updating yum"
