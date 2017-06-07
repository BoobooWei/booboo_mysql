#!/bin/bash
#mastera
step1(){
cat > masterafile  << ENDF
cat >> /etc/my.cnf << ENDFC
server-id=1
log-bin=/var/lib/mysql-log/mastera
# GTID
gtid_mode=on
enforce_gtid_consistency=1
# crash safe
sync_binlog=1
innodb_flush_log_at_trx_commit=1
# semi sync
# rpl‐semi_sync_master_enable=1
# rpl_semi_sync_master_timeout=1000 #ms
# rpl_semi_sync_master_warit_slave_count=num
ENDFC
mkdir /var/lib/mysql-log
chown mysql. /var/lib/mysql-log/
systemctl stop firewalld
setenforce 0
systemctl restart mysqld
mysql -uroot -p'(Uploo00king)' -e "grant replication slave on *.* to slave@'172.25.0.%' identified by '(Uploo00king)';flush privileges;"
mysqldump -uroot -p'(Uploo00king)' -A --single-transaction --master-data=2 > /tmp/mysql.all.sql
for i in 12 13 14;do scp /tmp/mysql.all.sql root@172.25.0.\$i:/tmp;done
ENDF
scp masterafile root@172.25.0.11:/tmp
ssh root@172.25.0.11 "bash /tmp/masterafile"
}

# masterb
step2(){
cat > masterbfile << ENDF
cat >> /etc/my.cnf << ENDFC
server-id=2
log-bin=/var/lib/mysql-log/masterb
# GTID
gtid_mode=on
enforce_gtid_consistency=1
# # semi sync
# # rpl‐semi_sync_slave_enable=1
# # MTS
slave_parallel_type=logical_clock
slave_parallel_workers=2
# # semi sync
# # rpl‐semi_sync_slave_enable=1
ENDFC
mkdir /var/lib/mysql-log/
chown mysql. /var/lib/mysql-log -R
systemctl restart mysqld
mysql -uroot -p'(Uploo00king)' < /tmp/mysql.all.sql
mysql -uroot -p'(Uploo00king)' -e "flush privileges;change master to master_user='slave',master_password='(Uploo00king)',master_host='172.25.0.11',master_auto_position=1;start slave;show slave status\G;"
ENDF
scp masterbfile root@172.25.0.12:/tmp
ssh root@172.25.0.12 "bash /tmp/masterbfile"

}

# mastera
step3(){
cat > mastera2file << ENDF
mysql -uroot -p'(Uploo00king)' -e "change master to master_user='slave',master_password='(Uploo00king)',master_host='172.25.0.12',master_auto_position=1;start slave;show slave status\G;"
ENDF
scp mastera2file root@172.25.0.11:/tmp
ssh root@172.25.0.11 "bash /tmp/mastera2file"
}

# slavea
step4(){
cat > slaveafile << ENDF
cat >> /etc/my.cnf << ENDFC
server-id=3
# GTID
gtid_mode=on
enforce_gtid_consistency=1
# semi sync
# rpl‐semi_sync_slave_enable=1
# MTS
slave_parallel_type=logical_clock
slave_parallel_workers=2
# semi sync
# rpl‐semi_sync_slave_enable=1
# Multisource
master-info-repository=table
relay-log-info-repository=table
ENDFC
systemctl restart mysqld
mysql -uroot -p'(Uploo00king)' < /tmp/mysql.all.sql
mysql -uroot -p'(Uploo00king)' -e "flush privileges;change master to master_user='slave',master_password='(Uploo00king)',master_host='172.25.0.11',master_auto_position=1 for channel 'mastera';change master to master_user='slave',master_password='(Uploo00king)',master_host='172.25.0.12',master_auto_position=1 for channel 'masterb';start slave;show slave status\G;"
ENDF
scp slaveafile root@172.25.0.13:/tmp
ssh root@172.25.0.13 "bash /tmp/slaveafile"
}

# slaveb
step4(){
cat > slavebfile << ENDF
cat >> /etc/my.cnf << ENDFC
server-id=3
# GTID
gtid_mode=on
enforce_gtid_consistency=1
# semi sync
# rpl‐semi_sync_slave_enable=1
# MTS
slave_parallel_type=logical_clock
slave_parallel_workers=2
# semi sync
# rpl‐semi_sync_slave_enable=1
# Multisource
master-info-repository=table
relay-log-info-repository=table
ENDFC
systemctl restart mysqld
mysql -uroot -p'(Uploo00king)' < /tmp/mysql.all.sql
mysql -uroot -p'(Uploo00king)' -e "flush privileges;change master to master_user='slave',master_password='(Uploo00king)',master_host='172.25.0.11',master_auto_position=1 for channel 'mastera';change master to master_user='slave',master_password='(Uploo00king)',master_host='172.25.0.12',master_auto_position=1 for channel 'masterb';start slave;show slave status\G;"
ENDF
scp slavebfile root@172.25.0.14:/tmp
ssh root@172.25.0.14 "bash /tmp/slavebfile"
}

main(){
step1
step2
step3
step4
}

main

