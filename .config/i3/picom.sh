#!/bin/bash

# Check if picom is running
if pgrep -x "picom" > /dev/null
then
    # If picom is running, kill it
    pkill picom
else
    # If picom is not running, start it
    picom --backend glx &
fi
