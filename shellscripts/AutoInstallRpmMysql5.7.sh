#!/bin/bash
#该脚本已有在线yum源地址为http://172.25.254.254/materials/mysql-5.7.repo
 
afile(){
cat > afile << ENDF
#!/bin/bash
yum install -y vim wget net-tools
wget http://172.25.254.254/materials/mysql-5.7.repo -P /etc/yum.repos.d && yum clean all && yum makecache
rpm -e --nodeps mariadb-libs
rm -rf /etc/my.cnf*
rm -rf /var/lib/mysql*
rm -rf /var/log/mariadb/
yum install -y mysql-community-server
systemctl start mysqld
password=\`grep password /var/log/mysqld.log | awk -F ': ' '{print \$2}'\` 
chown mysql. /usr/local/mysql-5.7.17-linux-glibc2.5-x86_64/ -R
mysqladmin -uroot -p\$password password '(Uploo00king)'
mysql -uroot -p'(Uploo00king)' -e "show databases"
ENDF
}


exe(){
for i in `seq 11 14`
do 
	scp afile root@172.25.$1.$i:~
	ssh root@172.25.$1.$i "bash afile"
done
}

afile 
exe $1
