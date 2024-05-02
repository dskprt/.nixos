#!/usr/bin/env bash

while true; do
	. $HOME/.e16/batmond2.sh
	sleep 30
done

# notified_20=false
# notified_10=false
# 
# while true; do
#     battery_info=$(acpi -b)
#     percentage=$(cat /sys/class/power_supply/BAT0/status)
#     status=$(cat /sys/class/power_supply/BAT0/capacity)
# 
#     #echo "$percentage $status"
#     
#     if [[ "$status" == "Discharging" ]]; then
#         if (( percentage <= 20 && !notified_20 )); then
#             notify-send "Battery" "20% remaining"
#             notified_20=true
#         elif (( percentage <= 10 && !notified_10 )); then
#             notify-send "Battery" "10% remaining. Plug in the AC adapter."
#             notified_10=true
#         elif (( percentage < 5 )); then
#         	notify-send "Battery" "Less than 5% remaining, putting the system to sleep."
#         	sleep 5
#             systemctl suspend
#         fi
#     else
#     	notified_20=false
#     	notified_10=false
#     fi
#     
#     sleep 2
# done
