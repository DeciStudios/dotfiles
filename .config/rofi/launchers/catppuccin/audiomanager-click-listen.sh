#!/bin/bash

# Launch the audiomanager application
audiomanager &

# Capture the PID of the audiomanager process
AUDIO_MANAGER_PID=$!

# Wait a few seconds to ensure the application window is up
sleep 2

# Get the window ID of the audiomanager application
WINDOW_ID=$(xdotool search --pid $AUDIO_MANAGER_PID | head -n 1)

# Function to monitor for clicks outside the window
check_click_outside() {
    while true; do
        # Monitor mouse click events using xev on the root window
        xev -root | grep --line-buffered ButtonPress | while read line; do
            # Get the window ID under the mouse cursor
            CLICK_WINDOW_ID=$(xdotool getmouselocation --shell | grep '^WINDOW=' | cut -d '=' -f 2)

            # If the click window ID is different from the audiomanager window ID, close the application
            if [ "$CLICK_WINDOW_ID" != "$WINDOW_ID" ]; then
                echo "Click detected outside the audiomanager window. Closing the application..."
                kill $AUDIO_MANAGER_PID
                exit
            fi
        done
        # Sleep briefly to avoid high CPU usage
        sleep 0.1
    done
}

# Start monitoring mouse clicks in the background
check_click_outside &
