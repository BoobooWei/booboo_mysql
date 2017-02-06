# MySQL 管理课程

[TOC]

![mysql图片](pic/00-mysql.png)


> * 教学对象：有一定linux基础
> * 数据库版本：maraidb5.5 mariadb10.2 mysql5.7
> * 操作系统：RHEL7.2 最小化安装

MySQL 管理课程，预计课时5天，说是说数据库，其实也属于项目的一部分，我们会发现在项目的当中，多多少少都会用到数据库，而且数据库还是一个重要的组成部分，在整个项目环境当中呢，我们会讲到项目的搭建、迁移、拓展，一台机器变成多台机器，解决用户的性能问题，那么在拓展过程当中呢，我们第一步拓展的都是数据库，因为数据库的压力是最大的，第一个遇到性能瓶颈的都是在数据库上面，所以的话呢，我们在MySQL的课程当中会主要以系统管理员的角度去讲讲数据库的备份、冗余、扩展、高可用、负载均衡。

## 为什么MySQL ?

DB-Engines 最近发布了 2017 年 2 月份的数据库排名。

前十名中，Oracle，MySQL 和 Microsoft SQL Server 仍占据前三名，Oracle 虽然长期霸占首位，但得分却呈下降趋势，与 1 月相比少了 12.89，与去年同期相比，少了 72.31。第二名的 MySQL 得分均有所上涨，与去年同期相比，增长 59.18，第三名的 Microsoft SQL Server 得分较 1 月下降了 17.5，比去年同期，得分有比较高的提升。

具体情况请看前 20 名排名情况：

![20170206-database-1.jpg](pic/20170206-database-1.jpg)

完整排名请看这里：http://db-engines.com/en/ranking

DB-Engines 排名的数据依据 5 个不同的因素：

* Google 以及 Bing 搜索引擎的关键字搜索数量
* Google Trends 的搜索数量
* Indeed 网站中的职位搜索量
* LinkedIn 中提到关键字的个人资料数
* Stackoverflow 上相关的问题和关注者数量

下图是每个数据库的变化趋势：

![20170206-database-2.jpg](pic/20170206-database-2.jpg)

可以看到，前 3 名一直保持着远高于其它数据库的地位，前三基本没有悬念。只是，第二名和第三名的MySQL 和 Microsoft SQL Server 已经越来越接近第一名的Oracle，说不定在下一次排名发布时，我们能看到不一样的三甲排名。

详细趋势请看这里：http://db-engines.com/en/ranking_trend

有人用python写了爬虫抓取国内网站数据制作了中国数据库排行榜。计算方法和db-engines类似，然而根据国内做了一些调整，统计结果是2017年1月MYSQL排名第一，得分为2864.75，而oracle得分为2752.67，sql server得分仅仅为981.5

我们还可以看看国内对mysql数据库工程师的招聘信息

![QQ截图20170206114205.png](pic/QQ截图20170206114205.png)

从上图看到2月6日这一天51job上对mysql dba的职位提供有316个，我们再看看对岗位的要求，如下图：

![20170206114325.png](pic/20170206114325.png)

为什么是 MySQL ?对每一种技术,我们都考虑了其最大关注点,并提出同样的问题。下面是我们对 MySQL 的考虑 :

Q：它解决了我们的存储需求吗? 

A：没错,我们需要映射、索引、排序和 blob 存储,这些MySQL 都有。

Q：它常用吗? 你可以招聘到相关员工吗?

A：MySQL 是目前生产线上最常使用的数据库之一。很容易招到使用过 MySQL 的人。

Q：它的社区活跃吗? 

A：非常活跃。有好多非常棒的书籍,和一个强大的在线社区。

Q：面对故障,它健壮吗?

A：即使在最恶劣的情况下,我们也从来没有丢失过数据。

Q：它的扩展性如何?

A：就它本身来说,只是一个很小的组件。我们需要一种上层的分片方案(这完全是另一个问题)。

Q：你会是最大的用户吗?

A：不, 目 前 不 是。 最 大 的 用 户 包 括 Facebook、Twitter 和 Google。除非你能够改进一种技术,否则你不会想要成为它最大的用户。如果你是最大的用户,你会碰到一些新的扩展性问题,而其他人根本没机会遇到。

Q：它的成熟度如何? 

A：真正的区别在于成熟度。根据复杂度的不同,成熟度就好比衡量完成一个程序所需的血、汗和泪。MySQL 的确复杂,但可比不上那些神奇的自动集群 NoSQL 方案。而且,MySQL 拥有 30 年(1996年第一版)最好和最聪明的贡献,来自于诸如Facebook 和 Google 那样大规模使用它的公司。根据我们的成熟度定义,在我们审查的所有技术中,MySQL 是一个明智的选择。

Q：有好的调试工具吗? 

A：作为一个成熟的产品,你当然需要强大的调试和分析工具,因为人们很容易遇到一些类似的棘手情况。比如你可能在凌晨三点遇到问题(不止一次)。相比用另一种技术重写一遍熬到凌晨六点,发现问题的根源然后回去睡觉舒服多了。

## Mysql 管理课程环境使用说明

DB100课程基于RHEL7.2系统，课程教授学生完成基于此系统的Mysql 5.7 、MariaDB 10.2数据库管理课程和基础课程内容。

### 授课网络环境配置如下

* workstation虚拟机均安装rhel7.2系统，（安装图形化界面并配置runlevel 5启动，root密码为uplooking ，配置了基础的YUM源指向classroom）， workstation虚拟机均配置了2块虚拟机网卡，eth0接入物理机br0网桥，动态获得ip地址172.25.0.10；eth1接入物理机private网桥，不获得ip地址；workstation虚拟机均配置2块虚拟硬盘（vda、vdb），以方便授课演示。workstation虚拟机均配置2GB运行内存。

* mastera、masterb、slavea 、slaveb 和dbproxy虚拟机均安装rhel7.2系统，（没有安装图形化界面，root密码为uplooking ，配置了基础的YUM源指向classroom）， mastera、masterb、slavea 、slaveb 和dbproxy虚拟机均配置了2块虚拟机网卡，eth0接入物理机br0网桥，动态获得ip地址172.25.0.11~172.25.0.5；eth1接入物理机private网桥，不获得ip地址；mastera、masterb、slavea 、slaveb 和dbproxy虚拟机均配置2块虚拟硬盘（vda、vdb），以方便授课演示。mastera、masterb、slavea 、slaveb 和dbproxy虚拟机均配置512MB运行内存。

* 已在classroom上完成DNS配置，正向和方向域名及邮件代理域名和虚拟机域名设置如下：
  - classroom.example.com 172.25.254.254
  - fN.example.com 172.25.254.N
  - workstationN.example.com 172.25.N.10
  - masteraN.example.com 172.25.N.11
  - masterbN.example.com 172.25.N.12
  - slaveaN.example.com 172.25.N.13
  - slavebN.example.com 172.25.N.14
  - dbproxyN.example.com 172.25.N.15
  - N:1~80

* http://classroom.example.com/materials 为第三方软件包和资料目录，也可以通过http://materials.example.com 直接访问。

### 注意事项
** Mariadb 10.2 和Mysql 5.7 在yum安装中会有冲突，不要同时配置MariaDB和MySQL的源。 **

### 网络拓扑图

![db100网络拓扑图](pic/01-db100-classroom.png)
