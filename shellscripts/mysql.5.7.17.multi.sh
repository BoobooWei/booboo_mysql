#!/bin/bash

DIR=`pwd`
DATE=`date +%Y%m%d%H%M%S`

\mv /alidata/mysql /alidata/mysql.bak.$DATE &> /dev/null
mkdir -p /alidata/mysql
mkdir -p /alidata/mysql/data
mkdir -p /alidata/mysql/log
mkdir -p /alidata/install
mkdir -p /data/data3307
mkdir -p /usr/local/mysql/bin/

cd /alidata/install
if [ `uname -m` == "x86_64" ];then
  rm -rf mysql-5.7.17-linux-glibc2.5-x86_64
  if [ ! -f mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz ];then
	 wget http://zy-res.oss-cn-hangzhou.aliyuncs.com/mysql/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz
  fi
  tar -xzvf mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz
  mv mysql-5.7.17-linux-glibc2.5-x86_64/* /alidata/mysql
#else
#  rm -rf mysql-5.7.17-linux-glibc2.5-i686
#  if [ ! -f mysql-5.7.17-linux-glibc2.5-i686.tar.gz ];then
#  wget http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.17-linux-glibc2.5-i686.tar.gz
#  fi
#  tar -xzvf mysql-5.7.17-linux-glibc2.5-i686.tar.gz
#  mv mysql-5.7.17-linux-glibc2.5-i686/* /alidata/mysql

fi

#install mysql
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

\cp -f /alidata/mysql/support-files/mysqld_multi.server /etc/init.d/mysqld_multi.server
sed -i 's#^basedir=/usr/local/mysql$#basedir=/alidata/mysql#' /etc/init.d/mysqld_multi.server
sed -i 's#^bindir=/usr/local/mysql/bin$#bindir=/alidata/mysql/bin#' /etc/init.d/mysqld_multi.server
cat > /etc/my.cnf <<END
[mysqld_multi]
mysqld     = /alidata/mysql/bin/mysqld_safe
mysqladmin = /alidata/mysql/bin/mysqladmin
log = /alidata/mysql/mysql_multi.log
user       = hjx
password   = 123456

[mysqld1]
socket     = /tmp/mysql.sock3306
port       = 3306
pid-file   = /alidata/mysql/data/mysql3306.pid
datadir    = /alidata/mysql/data

[mysqld2]
socket     = /tmp/mysql.sock3307
port       = 3307
pid-file   = /data/data3307/mysql3307.pid
datadir    = /data/data3307
END

chown -R mysql:mysql /alidata/mysql/
chown -R mysql:mysql /alidata/mysql/data/
chown -R mysql:mysql /data/data3307
ln -s /alidata/mysql/bin/mysqld /usr/local/mysql/bin/mysqld
/alidata/mysql/bin/mysqld --initialize-insecure --datadir=/alidata/mysql/data/  --user=mysql
/alidata/mysql/bin/mysqld --initialize-insecure --datadir=/data/data3307  --user=mysql
chmod 755 /etc/init.d/mysqld_multi.server

#add PATH
if ! cat /etc/profile | grep "export PATH=\$PATH:/alidata/mysql/bin" &> /dev/null;then
	echo "export PATH=\$PATH:/alidata/mysql/bin" >> /etc/profile
fi
source /etc/profile
cd $DIR
mysqld_multi --defaults-extra-file=/etc/my.cnf report
mysqld_multi --defaults-extra-file=/etc/my.cnf start 1,2
sleep 3
mysql -S /tmp/mysql.sock3306 -e "grant shutdown on *.* to hjx@localhost identified by '123456';flush privileges;"
mysql -S /tmp/mysql.sock3307 -e "grant shutdown on *.* to hjx@localhost identified by '123456';flush privileges;"
sed  -i "s#'my_print_defaults',#'my_print_defaults -s',#" /alidata/mysql/bin/mysqld_multi
# mysqld_multi --defaults-extra-file=/etc/my.cnf stop 1,2