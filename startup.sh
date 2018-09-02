#!/bin/bash
#
# This shell can only be executed after CentOS7 installed.
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
echo "set history=500000" >> /etc/vimrc
echo "set ignorecase" >> /etc/vimrc
echo "set smartcase" >> /etc/vimrc
echo "set hlsearch" >> /etc/vimrc
echo "set incsearch" >> /etc/vimrc
echo "set number" >> /etc/vimrc
echo "set list" >> /etc/vimrc
echo "set showmatch" >> /etc/vimrc
echo "set binary noeol" >> /etc/vimrc
echo "set autoindent" >> /etc/vimrc
echo "syntax on" >> /etc/vimrc
echo "highlight Comment ctermfg=LightCyan" >> /etc/vimrc

#8. install git
yum -y install git

#9. install ansible
yum -y install ansible

#10. install openldap phpldapadmin
yum -y install openldap-servers openldap-clients
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG 
chown ldap. /var/lib/ldap/DB_CONFIG 
systemctl start slapd 
systemctl enable slapd 

yum --enablerepo=epel -y install phpldapadmin

#11. install nginx
yum --enablerepo=epel -y install nginx
systemctl start nginx 
systemctl enable nginx
#firewall-cmd --add-service=http --permanent 
#firewall-cmd --reload

#12. install postgresql
yum --enablerepo=centos-sclo-rh -y install rh-postgresql96-postgresql-server
cat <<EOF >/etc/profile.d/rh-postgresql96.sh
#!/bin/bash
source /opt/rh/rh-postgresql96/enable
export X_SCLS="`scl enable rh-postgresql96 'echo $X_SCLS'`"
EOF
postgresql-setup --initdb --unit rh-postgresql96-postgresql 
systemctl start rh-postgresql96-postgresql
systemctl enable rh-postgresql96-postgresql 

#13. install redis
yum --enablerepo=epel -y install redis
systemctl start redis
systemctl enable redis

#14. install postfix
yum -y install postfix
systemctl restart postfix 
systemctl enable  postfix
#firewall-cmd --add-service=smtp --permanent  
#firewall-cmd --reload 

#15. install nagios
yum --enablerepo=epel -y install nagios nagios-plugins-{ping,disk,users,procs,load,swap,ssh,http}
systemctl start nagios 
systemctl enable nagios 
systemctl restart httpd
#firewall-cmd --add-service={http,https} --permanent 
#firewall-cmd --reload 

#15. install develop tolls
#zip unzip
yum -y install zip unzip
#java
yum -y install java-1.8.0-openjdk
#ruby
yum --enablerepo=centos-sclo-rh -y install rh-ruby25
scl enable rh-ruby25 bash
cat <<EOF >/etc/profile.d/rh-ruby25.sh
#!/bin/bash
source /opt/rh/rh-ruby25/enable
export X_SCLS="`scl enable rh-ruby25 'echo $X_SCLS'`"
EOF

#maven
curl -LO http://ftp.tsukuba.wide.ad.jp/software/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -xvzf apache-maven-3.5.4-bin.tar.gz -C /opt
cat <<EOF >> /etc/profile
export MAVAN_HOME=/opt/apache-maven-3.5.4
PATH=$PATH:$MAVAN_HOME/bin
export PATH
EOF
source /etc/profile
#gradle
curl -LO https://downloads.gradle.org/distributions/gradle-4.10-bin.zip
unzip -d /opt gradle-4.10-bin.zip
cat <<EOF >> /etc/profile
export GRADLE_HOME=/opt/gradle-4.10
PATH=$PATH:$GRADLE_HOME/bin
export PATH
EOF
source /etc/profile
#gitlab
curl -O https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh 
sh script.rpm.sh
yum -y install gitlab-ce
gitlab-ctl reconfigure
#readmine
#mattermost
#jenkins
curl -LO /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins
systemctl start jenkins.service
systemctl enable jenkins.service
#firewall-cmd --zone=public --permanent --add-port=8080/tcp
#firewall-cmd --reload
#sonarqube