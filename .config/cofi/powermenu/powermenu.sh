#!/usr/bin/env bash

# Get the directory of the script
script_dir=$(dirname "$(readlink -f "$0")")

launcher_type="$1"
# Set the rofi command with the theme path
rofi_command="rofi -theme $script_dir/type-$launcher_type/powermenu.rasi"

uptime=$(uptime -p | sed -e 's/up //g')

# Options
if [[ "$DIR" == "powermenus" ]]; then
	shutdown=""
	reboot=""
	lock=""
	suspend=""
	logout=""
	ddir="$script_dir/type-$launcher_type"
else

# For some reason the Icons are mess up I don't know why but to fix it uncomment section 2 and comment section 1 but if the section 1 icons are mess up uncomment section 2 and comment section 1

	# Buttons
	layout=`cat "$script_dir/type-$launcher_type/powermenu.rasi" | grep BUTTON | cut -d'=' -f2 | tr -d '[:blank:],*/'`
	if [[ "$layout" == "TRUE" ]]; then
  # Section 1

		shutdown=""
		reboot=""
		lock=""
		suspend=""
		logout=""
  # Section 2
#		shutdown="󰐥"
#		reboot="󰜉"
#		lock="󰍁"
#		suspend="󰒲"
#		logout="󰍃 "


	else
  # Section 1
		shutdown=" Shutdown"
		reboot=" Restart"
		lock=" Lock"
		suspend=" Sleep"
		logout=" Logout"
  # Section 2
#		shutdown="󰐥Shutdown"
#		reboot="󰜉 Restart"
#		lock="󰍁 Lock"
#		suspend="󰒲Sleep"
#		logout="󰍃 Logout"
	fi
	ddir="$script_dir/type-$launcher_type"
fi

# Ask for confirmation
rdialog () {
rofi -dmenu\
    -i\
    -no-fixed-num-lines\
    -p "Are You Sure? : "\
    -theme "$ddir/confirm.rasi"
}

# Display Help
show_msg() {
	rofi -theme "$ddir/askpass.rasi" -e "Options : yes / no / y / n"
}

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl poweroff
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $reboot)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl reboot
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $lock)
        betterlockscreen -l blur
        ;;
    $suspend)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
      betterlockscreen -l blur
    elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $logout)
		ans=$(rdialog &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
		  i3-msg exit
      hyprctl dispatch exit
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
esac
