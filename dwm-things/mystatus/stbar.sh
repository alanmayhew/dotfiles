#!/bin/sh

while true
do
	acpi_string=$(acpi -b)
	bat_percent=$(echo $acpi_string | cut -d ' ' -f4 | sed 's/,//g')
	bat_state=$(echo $acpi_string | cut -d ' ' -f3 | sed 's/,//g')

# 	bat_state_icon="&"
# 	if [ $bat_state = "Charging" ]; then
# 		bat_state_icon="↑"
# 	else
# 		bat_state_icon="↓"
# 	fi

	time_str=$(date +"%d %b %Y (%a) %r")
	net_ssid=$(/sbin/iwgetid | cut -d '"' -f2)
	# disp_brightness=$(xbacklight -get | cut -d '.' -f1)

	# get volume and status (muted or not -- "on" or "off")
	# vol_str_all=$(amixer sget Master | awk -F"[][]" '/dB/ { print $2, $6 }' )
	vol_str_all=$(amixer sget Master | awk -F"[][]" '/Front Left:/ { print $2, $4 }' )
	vol_num=$(echo $vol_str_all | cut -d ' ' -f1)
	vol_status=$(echo $vol_str_all | cut -d ' ' -f2)
	vol_mute=$( [ "$vol_status" = "off" ] && echo "X" || echo " ")

	caps_state=$(xset -q | sed -n -r "s/^.*Caps Lock:\s+(\S+)\s.*$/\1/p")
	caps_str=$( [ "$caps_state" = "on" ] && echo "[CAPS] |" || echo "")
	
	
	# xsetroot -name "$bat_percent ($bat_state) | $time_str"
	# xsetroot -name "WiFi: $net_ssid | * $disp_brightness * | $bat_percent ($bat_state) | $time_str"
	# xsetroot -name "WiFi: $net_ssid | $bat_percent ($bat_state) | $time_str"
	xsetroot -name "$caps_str WiFi: $net_ssid | $bat_percent ($bat_state) | Vol $vol_num ($vol_mute) | $time_str"
	
	sleep 1
done
