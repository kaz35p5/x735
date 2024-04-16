#!/bin/bash
#
# X735 Control Script with gpiod
#

# x735からのreboot/poweroff通知
SHUTDOWN=GPIO5
# reboot通知パルス幅 (msec)
REBOOTPULSEMINIMUM=200
REBOOTPULSEMAXIMUM=600

# x735へのBOOT完了通知
BOOT=GPIO12

# x735ボタン
BUTTON=GPIO20
# button押下時間(usec)
POWEROFF_TIME=1600000
REBOOT_TIME=600000

do_button() {
	local t=$1

	shutdownSignal=$(gpioget -B pull-down `gpiofind $SHUTDOWN`)

	if [ $shutdownSignal -eq 0 ]; then
		gpioset -m time -u $t `gpiofind $BUTTON`=1
		gpioset `gpiofind $BUTTON`=0
	fi
}

do_poweroff() {
	do_button $POWEROFF_TIME
}

do_reboot() {
	do_button $REBOOT_TIME
}

do_monitor() {
	# 入力設定
	pinctrl set $SHUTDOWN ip pd

	# 出力設定
	pinctrl set $BOOT op dh

	shutdown=`gpiofind $SHUTDOWN`

	while : ; do
		gpiomon -s -r -n 1 $shutdown

		shutdownSignal=1
		pulseStart=$(date +%s%N | cut -b1-13)
	
		while [ $shutdownSignal = 1 ]; do
			/bin/sleep 0.02
			if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMAXIMUM ]; then
				echo "X735 Shutting down ..."
				sudo poweroff
				exit
			fi
			shutdownSignal=`gpioget $shutdown`
		done
	
		if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMINIMUM ]; then
		echo "X735 Rebooting ..."
			sudo reboot
			exit
		fi
	done
}

case "$1" in
"poweroff") do_poweroff ;;
"reboot")   do_reboot ;;
"monitor")  do_monitor ;;
esac
