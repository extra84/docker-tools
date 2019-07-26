#!/bin/bash
for i in $(cat /etc/users.in); do 
	IFS=':' read -r -a array <<< $i 
	useradd -m ${array[0]} 
	echo ${array[0]}:${array[1]} | chpasswd -- 
done

