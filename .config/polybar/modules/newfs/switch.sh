#!/bin/bash

# Get the mountpoint from the command line argument
mountpoint="$1"

# Check if the mountpoint exists
if [ -d "$mountpoint" ]; then
    # Get the percentage used for the specified mountpoint
    percentage=$(df -h "$mountpoint" | awk 'NR==2{print $5}')
    echo "$percentage"
else
    echo "Invalid mountpoint"
fi
