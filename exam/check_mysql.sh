#!/bin/bash
#grant all on *.* to root@172.25.0.11 identified by '(Uploo00king)';flush privileges;

#!/bin/bash

SCORE=100
function print_MSG {
        local msg=$1
        echo -en "\033[1;34m$msg\033[0;39m "
}

function print_PASS {
  echo -e '\033[1;32mPASS\033[0;39m'
}

function print_FAIL {
  echo -en '\033[1;31mFAIL\033[0;39m '
  #echo -e "\033[1;31mSCORE-$1\033[0;39m"
  echo -e "\033[1;31m-$1\033[0;39m"
  SCORE=$(($SCORE - $1))
}
function print_SUCCESS {
  echo -e '\033[1;36mSUCCESS\033[0;39m'
}
function check1 { 
	echo "check AB-replication_mastera"
	echo "create database dbmastera1" | mysql -uroot -p'(Uploo00king)' -h 172.25.$1.12 &> /dev/null
	echo "show databases" | mysql -uroot -p'(Uploo00king)'  -h 172.25.$1.11 | grep "dbmastera1" &> /dev/null && print_SUCCESS || print_FAIL 10
	echo "check AB-replication_slavea"
	echo "show databases" | mysql -uroot -p'(Uploo00king)'  -h 172.25.$1.13 | grep "dbmastera1" &> /dev/null && print_SUCCESS || print_FAIL 10
	echo "check AB-replication_slaveb"
	echo "show databases" | mysql -uroot -p'(Uploo00king)'  -h 172.25.$1.14 | grep "dbmastera1" &> /dev/null && print_SUCCESS || print_FAIL 10
}
function check2 {
	echo "check mycat"
	ssh root@172.25.$1.15 "ps -ef|grep mycat" | grep "\-P.*\-s"  &> /dev/null && print_SUCCESS || print_FAIL 20
	echo "check workstation"
	ssh root@172.25.$1.10 "echo show databases|mysql -uphp -p'(Uploo00king)' -h 172.25.$1.15" &> /dev/null && print_SUCCESS || print_FAIL 10
}
function check3 {
	echo "check sql1,2,3"
	echo "select * from justice.t1" | mysql -uroot -p'(Uploo00king)'  -h 172.25.$1.11 | grep "3" &> /dev/null && print_SUCCESS || print_FAIL 10
	echo "check mysqldumpfile"
	ssh root@172.25.$1.10 "grep justice /tmp/mysql.all.sql" &> /dev/null && print_SUCCESS || print_FAIL 10
	echo "check sql4-30000"
	echo "select * from justice.t1" | mysql -uroot -p'(Uploo00king)'  -h 172.25.$1.11 | grep "28000" &> /dev/null && print_SUCCESS || print_FAIL 20
}




function check_ule_main {
        local num=$1
	echo
        print_MSG "1.check-ABreplication\n"
        check1 $num

        print_MSG "2.check-dbproxy\n"
        check2 $num

        print_MSG "3.mysqldump\n"
        check3 $num
	
}


case $1 in
        all)
                #. /etc/rht
                N_UM=$RHT_MAXSTATIONS
                for fun in $(seq 100 $N_UM) ; do
                        print_MSG "stu$N_um check exam\n"
                        check_ule_main $N_um
                        print_MSG "stu$N_um check end\n"
                done
                ;;
        [0-9]* )
                NUM=$1
                print_MSG "stu$NUM check begin\n"
                check_ule_main $NUM

                print_MSG "stu$NUM check end\n"
                ;;
        *)
                print_MSG "error $1\n"
                ;;
esac
echo -e "\t\033[1;31mYOUR SCORE IS:\033[0;39m \033[1;36m$SCORE\033[0;39m "
echo $1 $SCORE >> ~/mysqlstu1017.txt
