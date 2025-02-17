
cat "$HOME/.config/wofi/style.css" "$HOME/.config/wofi/powermenu.css" > /tmp/wofi_combined.css

op=$( echo -e "\n\n\n\n" | wofi -i --dmenu \
    --width 800 \
    --height 187 \
    --hide-scroll \
    --columns 5 \
    --allow-markup \
    --no-actions \
    --conf "$HOME/.config/wofi/powermenu" \
    --style "/tmp/wofi_combined.css" \
    | awk '{print tolower($1)}' )

case $op in 
        "")
                poweroff
                ;;
        "")
                reboot
                ;;
        "")
                systemctl suspend && hyprlock
                ;;
        "")
                hyprlock 
                ;;
        "")
                hyprctl dispatch exit
                ;;
esac
