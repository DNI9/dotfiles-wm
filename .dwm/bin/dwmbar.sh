#!/usr/bin/bash

interval=0

## Cpu Info
cpu_info() {
	cpu_load=$(grep -o "^[^ ]*" /proc/loadavg)
	printf "^c#3b414d^ ^b#7ec7a2^ CPU"
	printf "^c#abb2bf^ ^b#353b45^ %s" "$cpu_load"
}

## Memory
memory() {
	mem=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
	printf "^c#C678DD^^b#1e222a^   %s " "$mem"
}

## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "^c#3b414d^^b#7aa2f7^  ^d^%s" " ^c#7aa2f7^Connected " ;;
		down) printf "^c#3b414d^^b#E06C75^ 睊 ^d^%s" " ^c#E06C75^Disconnected " ;;
	esac
}

## Network Connection
network () {
	if [[ -n $ETHERNET_INTERFACE ]]; then
		interface=$ETHERNET_INTERFACE
	else
		interface=$(ip route | awk '/^default/ { print $5 ; exit }')
	fi

	[[ ! -d /sys/class/net/${interface} ]] && exit

	NETSTATUS=$(cat /sys/class/net/"$interface"/operstate 2>/dev/null)
	if [[ "$NETSTATUS" == "up" || "$NETSTATUS" == "unknown" ]]; then
		printf "^c#3b414d^^b#7aa2f7^   ^d^%s" " ^c#7aa2f7^Connected "
	else
		printf "^c#3b414d^^b#E06C75^ 睊 ^d^%s" " ^c#E06C75^Disconnected "
	fi
}

## Time
clock() {
	printf "^c#1e222a^^b#668ee3^  "
	printf "^c#1e222a^^b#7aa2f7^ %s " "$(date '+%a %d, %I:%M %p')"
}

## Network Speed
speed() {
  printf "^c#7aa2f7^ %s" "$(netspeed down)"
}

song_max_char=35
get_song_info() {
  if ! playerctl metadata > /dev/null 2>&1; then
    printf ""
    return
  fi
  song_info="$(playerctl metadata artist) - $(playerctl metadata title)"
  song_info_char=${#song_info}
  if test $((song_info_char)) -gt $((song_max_char)); then
    printf "^c#98C379^ "
    printf "^c#CADDEC^ %s..." "${song_info:0:$((song_max_char))}"
  else
    printf "^c#98C379^ "
    printf "^c#CADDEC^ %s" "$song_info"
  fi
}

## System Update
pkg_updates() {
	updates=$(checkupdates | wc -l)
	if [ "$updates" -eq 0 ]; then
		printf ""
	else
		printf "^c#98C379^  %s" "$updates"
	fi
}

## Battery Info
battery() {
	BAT=$(upower -i "$(upower -e | grep 'BAT')" | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i "$(upower -e | grep 'BAT')" | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "^c#E49263^  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf "^c#E06C75^  Full"
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		fi
	fi
}

## Brightness
brightness() {
	LIGHT=$(printf "%.0f\n" "$(light -G)")

	if [[ ("$LIGHT" -ge "0") && ("$LIGHT" -le "25") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "25") && ("$LIGHT" -le "50") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "50") && ("$LIGHT" -le "75") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "75") && ("$LIGHT" -le "100") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	fi
}

## Main
while true; do
	# check for package updates every 30min
  [ "$interval" == 0 ] || [ $(("$interval" % 1800)) == 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(get_song_info) $(speed) $updates $(battery) $(brightness) $(cpu_info) $(memory) $(network) $(clock)"
done
