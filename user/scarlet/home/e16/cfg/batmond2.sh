#!/usr/bin/env bash

NOTIFICATIONFILE=/tmp/.notificationSent

if [ ! -f $NOTIFICATIONFILE ]; then
    echo "0" > $NOTIFICATIONFILE
fi
read -r NOTIFICATIONSENT < /tmp/.notificationSent

BAT0=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

LEVELSUM=$((BAT0))

if [[ "$status" == "Charging" ]]; then
	exit 0
fi

if [ $LEVELSUM -le 5 ] && [ $NOTIFICATIONSENT -ne 5 ]; then
	notify-send -u critical "Low Battery" "Less than 5% remaining. Powering off in 30 seconds."
	sed -i 's/.*/5/' $NOTIFICATIONFILE
	sleep 30
	if [[ "$(cat /sys/class/power_supply/BAT0/status)" == "Charging" ]]; then
		exit 0
	fi
    systemctl poweroff
elif [ $LEVELSUM -le 10 ] && [ $NOTIFICATIONSENT -ne 10 ]; then
    notify-send -u critical "Low Battery" "$LEVELSUM% Remaining, plug in the AC adapter."
    sed -i 's/.*/10/' $NOTIFICATIONFILE
    pw-play $HOME/.e16/galaxy_low_battery.mp3 --volume 1.6
    sleep 1
    pw-play $HOME/.e16/galaxy_low_battery.mp3 --volume 1.6
elif [ $LEVELSUM -le 20 ] && [ $NOTIFICATIONSENT -ne 20 ]; then
    notify-send -u critical "Low Battery" "$LEVELSUM% Remaining."
    sed -i 's/.*/20/' $NOTIFICATIONFILE
    pw-play $HOME/.e16/galaxy_low_battery.mp3 --volume 1.6
fi
