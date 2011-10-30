#!/bin/sh

brightness_device="/sys/class/backlight/acpi_video0/brightness"
step=1

current=`cat $brightness_device`

if [[ "$1" == "up" ]]; then
  brightness=$(($current+$step))
else
  brightness=$(($current-$step))
fi

echo $brightness > $brightness_device
