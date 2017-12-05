#!/bin/bash
# Author: ben187

TOKEN=11111111111111111111111111111
CHAT_ID=111111111
URL=https://api.telegram.org/bot$TOKEN/sendMessage

IP='192.168.100.100'
COUNT=0
TEXT='host is down'

if ping -c 3 -s 5 -W 5 $IP | grep ttl;
then
COUNT=0
else
COUNT=$(($COUNT+1))
fi

if [[ $COUNT -eq 1 ]];
then
curl -i -s -X GET $URL -d text="$TEXT" -d chat_id=$CHAT_ID
else
> /dev/null
fi
