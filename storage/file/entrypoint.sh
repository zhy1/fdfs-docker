#!/bin/bash

STORAGE_BASE_PATH="/data/storage"
STORAGE_LOG_FILE="$STORAGE_BASE_PATH/logs/storaged.log"
STORAGE_CONF_FILE="/etc/fdfs/storage.conf"

echo "start fdfs_storgaed..."

ip=`cat /etc/hosts | grep $TRACKER | awk '{print $1}'`

sed -i "s/^.*tracker_server=.*$/tracker_server=${localIp}:22122/" /etc/fdfs/storage.conf
sed -i "s/^.*tracker_server=.*$/tracker_server=${localIp}:22122/" /etc/fdfs/client.conf
sed -i "s/^.*tracker_server=.*$/tracker_server=${localIp}:22122/" /etc/fdfs/mod_fastdfs.conf

fdfs_storaged "$STORAGE_CONF_FILE"
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
tail -f "$STORAGE_LOG_FILE"