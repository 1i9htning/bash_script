#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <can_interface_number>"
  exit 1
fi

CAN_INTERFACE_NUMBER=$1

if [ "$CAN_INTERFACE_NUMBER" -eq 1 ]; then
  CAN_INTERFACE="can0"
elif [ "$CAN_INTERFACE_NUMBER" -eq 2 ]; then
  CAN_INTERFACE="can1"
else
  echo "Invalid CAN interface number. Only 1 or 2 are supported."
  exit 1
fi

DETAILS=$(sudo ip -details link show $CAN_INTERFACE)

# 提取波特率
BITRATE=$(echo "$DETAILS" | grep -oP 'bitrate \K\d+')

if [ -z "$BITRATE" ]; then
  BITRATE_KBPS="N/A"
else
  BITRATE_KBPS=$(($BITRATE / 1000))
fi

# 如果波特率不为N/A，显示最后的K
if [ "$BITRATE_KBPS" != "N/A" ]; then
  BITRATE_KBPS="${BITRATE_KBPS}K"
fi

# 提取CAN状态
STATE=$(echo "$DETAILS" | grep -oP 'state \K\w+' | head -n 1)
CAN_STATE=$(echo "$DETAILS" | grep -oP 'can state \K\w+-\w+' | head -n 1)

# 如果状态是 DOWN，则显示为 STOPPED
if [ "$STATE" == "DOWN" ]; then
  CAN_STATE="STOPPED"
fi

# 提取当前CAN索引
CAN_INDEX="CAN${CAN_INTERFACE_NUMBER}"

# 输出关键信息
echo "当前CAN索引：$CAN_INDEX"
echo "波特率：$BITRATE_KBPS"
echo "状态：$STATE ($CAN_STATE)"