#!/bin/bash

TRACKER_BASE_PATH="/data/tracker"
TRACKER_LOG_FILE="$TRACKER_BASE_PATH/logs/trackerd.log"
TRACKER_CONF_FILE="/etc/fdfs/tracker.conf"

echo "start fdfs_trackerd..."
fdfs_trackerd $TRACKER_CONF_FILE
tail -f "$TRACKER_LOG_FILE"