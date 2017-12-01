#!/bin/bash
# Author: ben187

TOKEN=111111111111111111111111111111111111
CHAT_ID=1111111111
URL=https://api.telegram.org/bot$TOKEN/sendMessage

NGINX='nginx on vps is down'
PHP_FPM='php-fpm on vps is down'

COUNT_NGINX=0
COUNT_PHP_FPM=0

WHL=0

while [[ $WHL -lt 715 ]]; do

if /bin/systemctl status nginx.service | grep 'active (running)' ;
then
COUNT_NGINX=0
else
COUNT_NGINX=$(($COUNT_NGINX+1))
fi

if [[ $COUNT_NGINX -eq 1 ]];
then
curl -i -s -X GET $URL -d text="$NGINX" -d chat_id=$CHAT_ID
else
> /dev/null
fi

if /bin/systemctl status php-fpm.service | grep 'active (running)' ;
then
COUNT_PHP_FPM=0
else
COUNT_PHP_FPM=$(($COUNT_PHP_FPM+1))
fi

if [[ $COUNT_PHP_FPM -eq 1 ]];
then
curl -i -s -X GET $URL -d text="$PHP_FPM" -d chat_id=$CHAT_ID
else
> /dev/null
fi

WHL=$(( $WHL + 1 ))
echo  "$WHL"
sleep 5

done