#!/bin/bash
# Author: ben187

TOKEN=11111111111111111111111111111
CHAT_ID=111111111
URL=https://api.telegram.org/bot$TOKEN/sendMessage

NGINX='nginx on 192.168.100.227 is down'
PHP_FPM='php-fpm on 192.168.100.227 is down'
ACTIVE="active"

STATUS_NGINX=`service nginx status | grep Active:`
STATUS_NGINX1=`echo $STATUS_NGINX |grep Active: | cut -d ' ' -f 2- |awk '{print $1}'`
if [[ "$STATUS_NGINX1" != "$ACTIVE" ]]; then
curl -i -s -X GET $URL -d text="$NGINX" -d chat_id=$CHAT_ID
fi

STATUS_PHP_FPM=`service php-fpm status | grep Active:`
STATUS_PHP_FPM1=`echo $STATUS_PHP_FPM |grep Active: | cut -d ' ' -f 2- |awk '{print $1}'`
if [[ "$STATUS_PHP_FPM1" != "$ACTIVE" ]]; then
curl -i -s -X GET $URL -d text="$PHP_FPM" -d chat_id=$CHAT_ID
fi
