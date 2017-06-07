#!/bin/bash

cat > installmycat.sh << ENDFA
#获取mycat和jdk软件
get_software(){
yum install -y vim wget net-tools
wget http://172.25.254.254/content/ule/DB100_mysql/sides/soft/db-proxy/mycat/jdk-7u79-linux-x64.rpm
wget http://172.25.254.254/content/ule/DB100_mysql/sides/soft/db-proxy/mycat/Mycat-server-1.5.1-RELEASE-20160328130228-linux.tar.gz
}

#安装jdk并宣告java家目录
install_jdk(){
rpm -ivh jdk-7u79-linux-x64.rpm
sed -i '\$a export JAVA_HOME=/usr/java/jdk1.7.0_79/' /etc/bashrc
source /etc/bashrc
echo \$JAVA_HOME
}

#安装mycat，并优化路径
install_mycat(){
tar -xf Mycat-server-1.5.1-RELEASE-20160328130228-linux.tar.gz -C /usr/local
sed -i '\$a export MYCAT_HOME=/usr/local/mycat' /etc/bashrc
sed -i '\$a export PATH=\${PATH}:\${MYCAT_HOME}/bin' /etc/bashrc
source /etc/bashrc
echo \$MYCAT_HOME
}
get_software
install_jdk
install_mycat
ENDFA

scp installmycat.sh root@172.25.0.15:/tmp
ssh root@172.25.0.15 "bash /tmp/installmycat.sh" 
