#!/bin/bash
# 该脚本可以带位置参数执行，位置参数为你的机号，例如我是0号，则：
#[root@workstation0 ~]# bash AutoInstallBinMysql5.7.sh 0
# 二进制安装
# 软件位置

software="http://172.25.254.254/content/ule/DB100_mysql/sides/soft/mysql5.7/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz"

soft(){
wget $software
tar -xf mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz  
for i in `seq 11 14`;do scp -r mysql-5.7.17-linux-glibc2.5-x86_64 root@172.25.$1.$i:/usr/local;done
}

afile(){
cat > afile << ENDF
#!/bin/bash
rpm -e --nodeps mariadb-libs
rm -rf /etc/my.cnf*
rm -rf /var/lib/mysql*
rm -rf /var/log/mariadb/
useradd mysql
ln -s  /usr/local/mysql-5.7.17-linux-glibc2.5-x86_64/ /usr/local/mysql
cd /usr/local/mysql
bin/mysqld --initialize &> mysql.log
password=\`grep password mysql.log | awk -F ': ' '{print \$2}'\` 
chown mysql. /usr/local/mysql-5.7.17-linux-glibc2.5-x86_64/ -R
support-files/mysql.server start
bin/mysqladmin -uroot -p\$password password '(Uploo00king)'
bin/mysql -uroot -p'(Uploo00king)' -e "show databases"
ENDF
}


exe(){
for i in `seq 12 14`
do 
	scp afile root@172.25.$1.$i:~
	ssh root@172.25.$1.$i "bash afile"
done
}

soft $1
afile
exe $1

