这是一个针对初学者的教程。工作进阶请点击[MySLQ 进阶](https://github.com/BoobooWei/DBA_Mysql)

```shell
MYSQL
一、MySQL管理课程简介
1.MySQL 管理课程
2.为什么MySQL ?
3.Mysql 管理课程环境使用说明
4.授课网络环境配置如下
5.注意事项
6.网络拓扑图

二、MySQL和MariaDB数据库介绍
1.数据库的基础概念
2.数据库的分类
3.什么是MySQL
4.如何获得MySQL相关资源
5.MySQL在企业中的应用场景
6.MySQL 数据库安装
	RHEL 7.2 RPM 包安装 MariaDB 5.5
	RHEL 7.2 RPM 包安装 MariaDB 10.2
	RHEL 7.2 RPM 包安装 MySQL 5.7
	RHEL 7.2 二进制文件安装 MySQL 5.6
7.MySQL客户端连接数据库
	MySQL客户端的使用
	python连接MySQL数据库
	PHPmyAdmin在线工具使用
	MySQL Workbench 连接数据库

三、结构化查询语言SQL介绍和基本操作
1.sql语法，数据类型，运算符
2.DDL(Data Definition Languages)语句
3.DML(Data Manipulation Language)语句
4.DCL(Data Control Language)语句
5.DQL(Data Query Language)语句
6.实战项目1:熟悉SQL语句
7.实战项目2:熟悉mysql.user表
8.实战项目3:完成数据库用户权限操作项目

四、MySQL逻辑架构和Innodb存储引擎
1.MySQL 逻辑架构
2.MySQL 存储引擎
	存储引擎概述
	知名的两大存储引擎
	事务
	并发控制
	锁机制
	多版本并发控制 MVCC
	事务的隔离级别
3.INNODB锁
	设置INNODB事务隔离级别
		实践1：查看innodb默认的事务隔离级别
		实践2：改变单个会话的隔离级别
		实践3：改变单个实例的隔离级别
		实践4：改变所有实例的隔离级别
	区分INNODB事务隔离级别
		InnoDB 中的隔离级详细描述
		实践1：SERIALIZABLE隔离级别查询自动加共享锁
		实践2：RU、RC、RR隔离级别的对比
	实现一致性锁定读
		实践1：设置innodb申请锁等待超时时间
		实践2：设置一致性锁定读，加共享锁测试
		实践3：设置一致性锁定读，加排他锁测试
	认识锁的算法
		知识点
		实践1： 验证nextkey
		lock降级为record key
		实践2： 关闭GAP锁_RC
		实践3： 关闭GAP锁_innodb_locks_unsafe_for_binlog
		实践4： nextkeylocking是如何解决幻读问题的

五、MySQL备份与恢复

1.为什么要备份
2.什么是备份
3.备份的两大要素
4.备份的分类
	物理备份和逻辑备份
		逻辑备份
		物理备份
	增量备份和差异备份
	在线（热）备份、温备份、离线（冷）备份
5.备份和恢复工具
	tar
		tar备份步骤
		tar还原步骤
		课堂实战1: 利用tar实现物理备份并还原
	LVM SnapShot
		lvm快照的优点和缺点
		os支持lvm方式 
		lvm快照备份数据
		lvm快照还原数据
		课堂实战2: 利用LVM快照实现物理备份并还原
	mysqldump
		MyISAM和INNODB表的备份
		mysqldump命令的用法
		mysqldump备份步骤
		mysqldump还原步骤
		课堂实战3: 利用mysqldump实现逻辑备份并还原
	Percona Xtrabackup
	课堂实战4：innobackupex实时增量备份和还原
6.MySQL 日志的分类
	二进制日志的管理和备份
		如何打开二进制日志
		如何查看二进制日志
		基于二进制日志的实时增量还原
	数据库备份恢复模拟一
	数据库备份恢复模拟二
	数据库备份恢复模拟三
	课堂实战5：基于二进制日志时间点和位置的数据库备份恢复模拟

六、MySQL复制replication 
1.复制概述
2.复制解决的问题
3.复制的原理
	项目实战1：mariadb server 5.5 单主从架构
	项目实战2：mysql server 5.7 基于GTID的单主从架构
4.复制中的延迟问题_重演延迟
	项目实战3：mysql server 5.7 基于GTID的并行MTS单主从架构
	项目实战4：mysql server 5.7 基于GTID的并行MTS单主从架构crash safe参数调优
5.复制中的延迟问题_读写分离
	半同步复制的潜在问题
	无数据丢失的半同步复制
	项目实战5：mysql server 5.7 基于GTID的并行MTS单主从半同步架构
6.复制中的单点故障问题
	复制拓扑_配置MSS
	复制拓扑_配置MM
	复制拓扑_配置M(s)M(s)
	复制拓扑_配置MMSS
	项目实战6：mysql server 5.7 基于GTID的并行MTS多级主从 Multisource 半同步架构

七、MySQL高可用HA
1.什么是高可用
2.导致宕机的原因
3.如何实现高可用
4.避免单点故障
	基于复制的冗余
	MySQL 同步复制
		MySQL Cluster 集群
		Galera Cluster 集群
5.故障转移和故障恢复
	问题的提出
	解决方案
	什么是数据库代理服务器
	目前市面上的数据库代理服务器
		mysqlproxy (了解，不讲)
		mycat
6.实战项目： 数据库中间件 Mycat 实现 读写分离负载均衡，后端数据库服务器为 MySQL 5.7 MMSS Multisource Replication 高可用架构
7.实战项目:  数据库中间件 Mycat 实现 读写分离负载均衡，后端数据库服务器为 Mariadb 10.2 Galera Cluster同步复制高可用架构
```
