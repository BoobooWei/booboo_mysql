# MySQL5.6一主多从半同步复制

>要求掌握mysql5.6的二进制安装和AB replication之半同步复制

| role   | server  | ip          |
| :----- | :------ | :---------- |
| master | mastera | 172.25.0.11 |
| slave  | masterb | 172.25.5.12 |
| slave  | slavea  | 172.25.5.13 |

## 安装二进制的mysql5.6

```shell	
[root@mastera0 ~]# tar -xf mysql-5.6.20-linux-glibc2.5-x86_64.tar.gz 
[root@mastera0 ~]# cd mysql-5.6.20-linux-glibc2.5-x86_64
[root@mastera0 mysql-5.6.20-linux-glibc2.5-x86_64]# ls
bin  COPYING  data  docs  include  INSTALL-BINARY  lib  man  mysql-test  README  scripts  share  sql-bench  support-files
[root@mastera0 mysql-5.6.20-linux-glibc2.5-x86_64]# cat INSTALL-BINARY
... ...
 To install and use a MySQL binary distribution, the basic command
   sequence looks like this:
shell> groupadd mysql
shell> useradd -r -g mysql mysql
shell> cd /usr/local
shell> tar zxvf /path/to/mysql-VERSION-OS.tar.gz
shell> ln -s full-path-to-mysql-VERSION-OS mysql
shell> cd mysql
shell> chown -R mysql .
shell> chgrp -R mysql .
shell> scripts/mysql_install_db --user=mysql
shell> chown -R root .
shell> chown -R mysql data
shell> bin/mysqld_safe --user=mysql &
# Next command is optional
shell> cp support-files/mysql.server /etc/init.d/mysql.server
... ...

[root@mastera0 mysql-5.6.20-linux-glibc2.5-x86_64]# groupadd mysql
[root@mastera0 mysql-5.6.20-linux-glibc2.5-x86_64]# cd ..
[root@mastera0 ~]# useradd -r -g mysql mysql
[root@mastera0 ~]# cd /usr/local
[root@mastera0 local]# mv /root/mysql-5.6.20-linux-glibc2.5-x86_64 .
[root@mastera0 local]# ls
bin  games    lib    libexec                             sbin   src
etc  include  lib64  mysql-5.6.20-linux-glibc2.5-x86_64  share
[root@mastera0 local]# ln -s mysql-5.6.20-linux-glibc2.5-x86_64 mysql
[root@mastera0 local]# ll mysql
lrwxrwxrwx.  1 root root   34 Dec 11 12:20 mysql -> mysql-5.6.20-linux-glibc2.5-x86_64
[root@mastera0 mysql]# cd mysql
[root@mastera0 mysql]# mkdir /data/mysql/data -p
[root@mastera0 mysql]# chown mysql. /data/mysql/data
[root@mastera0 mysql]# chown mysql. /data/mysql/data -R
[root@mastera0 mysql]# ll -d /data/mysql/data
drwxr-xr-x. 2 mysql mysql 4096 Dec 11 12:24 /data/mysql/data
[root@mastera0 mysql]# scripts/mysql_install_db --user=mysql --datadir=/data/mysql/data --basedir=/usr/local/mysql

[root@mastera0 mysql]# ll /data/mysql/data
total 110604
-rw-rw----. 1 mysql mysql 12582912 Dec 11 12:28 ibdata1
-rw-rw----. 1 mysql mysql 50331648 Dec 11 12:28 ib_logfile0
-rw-rw----. 1 mysql mysql 50331648 Dec 11 12:28 ib_logfile1
drwx------. 2 mysql mysql     4096 Dec 11 12:28 mysql
drwx------. 2 mysql mysql     4096 Dec 11 12:28 performance_schema
drwx------. 2 mysql mysql     4096 Dec 11 12:28 test
[root@mastera0 mysql]# cp /mnt/mysql/my.cnf /etc/my.cnf
[root@mastera0 mysql]# vim /etc/my.cnf
[client]
#如果不认识这个参数会忽略
loose-default-character-set=utf8
loose-prompt='\u@\h:\p [\d]>'
socket=/tmp/mysql.sock

[mysqld]
basedir = /usr/local/mysql
datadir = /data/mysql/data
user=mysql
port = 3306
socket=/tmp/mysql.sock
pid-file=/data/tmp/mysql.pid
tmpdir=/data1/tmp
character_set_server=utf8

#skip
skip-external_locking=1
skip-name-resolve=1

#AB replication
server-id = 1
log-bin = /data/mysql/log-data/mastera
binlog_format=row
max_binlog_cache_size=2000M
max_binlog_size=1G
sync_binlog=1
#expire_logs_days=7

#semi_sync
rpl_semi_sync_master_enabled=1
rpl_semi_sync_master_timeout=1000


[root@mastera0 mysql]# pwd
/usr/local/mysql
[root@mastera0 mysql]# cp support-files/mysql.server /etc/init.d/mysql.server
[root@mastera0 mysql]# echo export PATH=$PATH:/usr/local/mysql/support-files/ >> /etc/bashrc
```

| mysql    | 软件架构                 |
| :------- | :------------------- |
| 数据目录     | /data/mysql/data     |
| binlog目录 | /data/mysql/log-data |
| pid文件    | /data/tmp            |
| 临时目录     | /data1/tmp/          |

以上目录所属者和所属组都需要为mysql.mysql

同样去安装masterb slavea

---

## 配置主从

步骤忽略


## 配置主从半同步模式

>安装半同步插件
```shell
	>install plugin rpl_semi_sync_master soname 'semisync_master.so';
	>install plugin rpl_semi_sync_slave soname 'semisync_slave.so';
```

>配置文件中需要打开相应的参数
```shell
	rpl_semi_sync_master_enabled=1
	rpl_semi_sync_master_timeout=1000 #ms
	rpl_semi_sync_slave_enabled=1
```

>重新启动服务

>测试

```shell
mastera
root@localhost:mysql.sock [(none)]>show variables like "%semi%";
+------------------------------------+-------+
| Variable_name                      | Value |
+------------------------------------+-------+
| rpl_semi_sync_master_enabled       | ON    |
| rpl_semi_sync_master_timeout       | 1000  |
| rpl_semi_sync_master_trace_level   | 32    |
| rpl_semi_sync_master_wait_no_slave | ON    |
| rpl_semi_sync_slave_enabled        | OFF   |
| rpl_semi_sync_slave_trace_level    | 32    |
+------------------------------------+-------+
6 rows in set (0.00 sec)

masterb
root@localhost:mysql.sock [(none)]>show variables like "%semi%";
+------------------------------------+-------+
| Variable_name                      | Value |
+------------------------------------+-------+
| rpl_semi_sync_master_enabled       | OFF   |
| rpl_semi_sync_master_timeout       | 10000 |
| rpl_semi_sync_master_trace_level   | 32    |
| rpl_semi_sync_master_wait_no_slave | ON    |
| rpl_semi_sync_slave_enabled        | ON    |
| rpl_semi_sync_slave_trace_level    | 32    |
+------------------------------------+-------+
6 rows in set (0.00 sec)

slavea
root@localhost:mysql.sock [(none)]>show variables like "%semi%";
+------------------------------------+-------+
| Variable_name                      | Value |
+------------------------------------+-------+
| rpl_semi_sync_master_enabled       | OFF   |
| rpl_semi_sync_master_timeout       | 10000 |
| rpl_semi_sync_master_trace_level   | 32    |
| rpl_semi_sync_master_wait_no_slave | ON    |
| rpl_semi_sync_slave_enabled        | ON    |
| rpl_semi_sync_slave_trace_level    | 32    |
+------------------------------------+-------+
6 rows in set (0.00 sec)
```

现在将masterb和slavea的slave关闭，在mastera上进行写操作，并观察。

```shell
root@localhost:mysql.sock [(none)]>insert into db1.t1 values (2);
Query OK, 1 row affected (1.29 sec)

root@localhost:mysql.sock [(none)]>insert into db1.t1 values (3);
Query OK, 1 row affected (0.20 sec)

root@localhost:mysql.sock [(none)]>insert into db1.t1 values (4);
Query OK, 1 row affected (0.22 sec)
```

当mastera等待1000ms也就是1s后，就不等了，所以看到消耗1.29s，而之后的插入就变成异步了。

