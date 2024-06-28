#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: $0 <can_interface_number> <bitrate_kbps>"
  exit 1
fi

CAN_INTERFACE_NUMBER=$1
BITRATE_KBPS=$2

if [ "$CAN_INTERFACE_NUMBER" -eq 1 ]; then
  CAN_INTERFACE="can0"
elif [ "$CAN_INTERFACE_NUMBER" -eq 2 ]; then
  CAN_INTERFACE="can1"
else
  echo "Invalid CAN interface number. Only 1 or 2 are supported."
  exit 1
fi

BITRATE=$(($BITRATE_KBPS * 1000))

sudo ip link set $CAN_INTERFACE down
sudo ip link set $CAN_INTERFACE type can bitrate $BITRATE
sudo ip link set $CAN_INTERFACE up

echo "Configured $CAN_INTERFACE with bitrate ${BITRATE_KBPS}kbps ($BITRATE)."