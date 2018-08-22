#!/bin/bash
nmap -Pn 192.168.0.0-254 -p 34567 | grep -B 3 open |  grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' >> nmap.log


#!/bin/bash
>nmap.log
>nmap.ip

echo "Start nmap" >>  nmap.log
date >> nmap.log

time=$(date +%s)
var=0

while [ $var -lt 255 ]
do
nmap -Pn 192.168.$var.0-255 -p 34567 | grep -B 3 open |  grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' >> nmap.ip
var=$[ $var + 1 ]
echo "Scanned network 192.168.$var.0/24" >> nmap.log
done

date >> nmap.log
echo "Script done, spent time $(($(date +%s)-$time))s" >> nmap.log
