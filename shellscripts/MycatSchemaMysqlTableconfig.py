#!/usr/bin/python
# -*- coding: utf-8 -*-
#实现mycat schema.xml的table配置段自动生成
#需要额外安装Mysql-python模块
#Usage: python MycatSchemaMysqlTableconfig.sh "use ecshop;show tables"

import MySQLdb
import sys
server='172.25.0.11'
user='mycat'
password='(Uploo00king)'
dbname='ecshop'
sql=sys.argv[1]
db=MySQLdb.connect(server,user,password,dbname)
c=db.cursor()
c.execute(sql)
data=c.fetchall()
for i in data:
	a_str='''	<table name="'''+str(i[0])+'''" dataNode="dn1" />\n'''
	sys.stdout.write(a_str)
db.close()


