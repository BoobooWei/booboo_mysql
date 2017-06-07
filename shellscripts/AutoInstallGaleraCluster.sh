#!/bin/bash
# bash shell脚本实现集群自动部署
# Usage: bash AutoInstallGaleraCluster.sh

#安装软件
install_cluster(){
for i in `seq 11 14`;do ssh  root@172.25.0.$i "systemctl stop firewalld;setenforce 0";done
for i in `seq 11 14`;do ssh  root@172.25.0.$i "wget http://172.25.254.254/materials/mariadb-10.2.repo -P /etc/yum.repos.d ; wget http://172.25.254.254/materials/thirdpart.repo -P /etc/yum.repos.d/; yum makecache;rpm -e --nodeps mariadb-libs";done
for i in `seq 12 14`;do ssh  root@172.25.0.$i "yum install -y MariaDB-server" galera jemalloc*;done
}
#分发配置
distribute_configure(){
for i in `seq 11 14`;do 
if [ $i == 11 ] ;then
	ip=172.25.0.11
	hostname=mastera0
fi
if [ $i == 12 ] ;then
	add=172.25.0.11
	ip=172.25.0.12
	hostname=masterb0
fi
if [ $i == 13 ] ;then
	add=172.25.0.11
	ip=172.25.0.13
	hostname=slavea0
fi
if [ $i == 14 ] ;then
	add=172.25.0.11
	ip=172.25.0.14
	hostname=slaveb0
fi
cat > galera${i}.cnf << ENDF
[galera]
wsrep_on=ON
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://$add"
wsrep_cluster_name="galera"
wsrep_node_address="$ip"
wsrep_node_name="${hostname}.example.com"
wsrep_sst_method=rsync
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0
ENDF
scp galera${i}.cnf root@$ip:/etc/my.cnf.d
done
}
#启动集群
init_cluster(){
ssh root@172.25.0.11 "systemctl start mariadb"
for i in 12 13 14;do ssh root@172.25.0.$i "systemctl start mariadb";done
}
install_cluster
distribute_configure
init_cluster
