#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <channel> <ID1> [<ID2> ...]"
    echo "  channel: 1 for can0, 2 for can1"
    exit 1
fi

CHANNEL=$1
shift
IDS=("$@")
ERROR_REPORTED=false

if [ "$CHANNEL" -eq 1 ]; then
    CAN_CHANNEL="can0"
elif [ "$CHANNEL" -eq 2 ]; then
    CAN_CHANNEL="can1"
else
    echo "Invalid channel number. Should be 1 (can0) or 2 (can1)."
    exit 1
fi

while true; do
    candump $CAN_CHANNEL 2>&1 | while read -r line; do
        timestamp=$(date +"[%Y-%m-%d %H:%M:%S.%N]")
        formatted_timestamp=$(echo "$timestamp" | sed 's/\([0-9]\{3\}\)\([0-9]\{3\}\)\([0-9]\{3\}\)/\1.\2.\3/')
        if [[ "$line" == *"Network is down"* ]]; then
            if [ "$ERROR_REPORTED" = false ]; then
                echo "$timestamp Network is down"
                ERROR_REPORTED=true
            fi
        else
            if [ "$ERROR_REPORTED" = true ]; then
                echo "$timestamp Network is up"
                ERROR_REPORTED=false
            fi
            for id in "${IDS[@]}"; do
                echo "$formatted_timestamp $line" | grep "$id"
            done
        fi
    done
    sleep 1
done
