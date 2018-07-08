#!/bin/bash
#
#test exec user
echo "test exec user"
if (whoami != root)
    echo "Please run as root"
    exit 9
fi
#check internet connection access
echo "test internet connection access"
test_ip=`ip r | grep default | cut -d ' ' -f 3`
if $test_ip="" then
    echo "Please run as root"
    exit 9
fi
access_flg=`ping -q -w 1 -c 1 $test_ip > /dev/null && echo 0 || echo 9`
if $access_flg




echo "Auto starting setting up centos server........"
echo "setup 1: auto updating yum"

 
