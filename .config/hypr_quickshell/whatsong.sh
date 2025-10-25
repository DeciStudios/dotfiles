#!/bin/bash

# Check for mpd (Music Player Daemon) status
if command -v mpc &> /dev/null; then
    song=$(mpc current)
    if [ -z "$song" ]; then
        echo "No song playing in MPD"
    else
        echo "Currently playing in MPD: $song"
    fi
# Check for spotify-cli (spotify-tui or any other Spotify CLI tool)
elif command -v spotify-cli &> /dev/null; then
    song=$(spotify-cli current)
    if [ -z "$song" ]; then
        echo "No song playing in Spotify"
    else
        echo "Currently playing in Spotify: $song"
    fi
# Check for running a media player like VLC or similar
elif command -v vlc &> /dev/null; then
    song=$(vlc --list)
    if [ -z "$song" ]; then
        echo "No song playing in VLC"
    else
        echo "Currently playing in VLC: $song"
    fi
else
    echo ""
fi
