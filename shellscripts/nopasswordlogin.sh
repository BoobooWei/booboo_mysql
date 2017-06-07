#!/bin/bash
ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa 
for i in `seq 10 15`;do ssh-copy-id root@172.25.0.$i ;done
for i in `seq 10 15`;do ssh root@172.25.0.$i date ;done
