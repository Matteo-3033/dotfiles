#!/bin/bash

DEFAULT_IP="192.168.1.6"

IP="${1:-$DEFAULT_IP}"

sudo modprobe v4l2loopback devices=1 video_nr=2 card_label="Phone Webcam" exclusive_caps=1

ffmpeg -f mjpeg -i "https://$IP:8080/video" \
  -vf "scale=1280:720,format=yuyv422" \
  -f v4l2 -pix_fmt yuyv422 /dev/video4

