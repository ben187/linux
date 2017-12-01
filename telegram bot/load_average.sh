#!/bin/bash
# Author: ben187

TOKEN=111111111111111111111111111111111111
CHAT_ID=1111111111
URL=https://api.telegram.org/bot$TOKEN/sendMessage

WARNING=1
WHL=0
COUNT=0

while [[ $WHL -lt 11 ]]; do

UPTIME=`uptime`
LOAD_AVERAGE=`uptime | grep -o .[0-9].[0-9][0-9] | head -n3 | tail -n1 | cut -c -2`

if [[ $LOAD_AVERAGE -ge $WARNING ]];
then
COUNT=$(($COUNT+1))
else
COUNT=0
fi

if [[ $COUNT -eq 1 ]];
then
curl -i -s -X GET $URL -d text="VPS $UPTIME" -d chat_id=$CHAT_ID
else
> /dev/null
fi

WHL=$(( $WHL + 1 ))
echo "$LOAD_AVERAGE"
sleep 5

done
