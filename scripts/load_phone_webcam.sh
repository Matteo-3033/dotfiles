#!/bin/bash

# Parameters
V4L2_DEVICE="/dev/video4"
CARD_LABEL="Phone Camera"
WIDTH=1280
HEIGHT=720
DEFAULT_IP="192.168.1.6"
PORT=8080
ENDPOINT="video"

# Verify dependencies
for cmd in adb ffmpeg; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed!"
        exit 1
    fi
done

# Create virtual video device
sudo modprobe v4l2loopback devices=1 video_nr=4 card_label="$CARD_LABEL" exclusive_caps=1

# Check if phone is connected via ADB
if adb devices | grep -q -v "List of devices"; then
    echo "Phone detected via USB, using ADB port forwarding"
    adb wait-for-usb-device
    adb forward tcp:$PORT tcp:$PORT
    VIDEO_URL="http://127.0.0.1:$PORT/$ENDPOINT"
else
    echo "No phone detected via ADB, using default IP or provided IP"
    IP="${1:-$DEFAULT_IP}"
    VIDEO_URL="https://$IP:$PORT/$ENDPOINT"
fi

# Stream video to virtual device
ffmpeg -y -i "$VIDEO_URL" \
    -vf "scale=${WIDTH}:${HEIGHT},format=yuyv422" \
    -f v4l2 -pix_fmt yuyv422 $V4L2_DEVICE

