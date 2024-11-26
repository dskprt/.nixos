#!/usr/bin/env bash

read TPdevice <<< $( xinput | sed -nre '/TouchPad|Touchpad/s/.*id=([0-9]*).*/\1/p' )
state=$( xinput list-props "$TPdevice" | grep "Device Enabled" | grep -o "[01]$" )

if [ "$state" -eq '1' ];then
    xinput --disable "$TPdevice" && kdialog --title "System" --passivepopup "Touchpad disabled" 1
else
    xinput --enable "$TPdevice" && kdialog --title "System" --passivepopup "Touchpad enabled" 1
fi
