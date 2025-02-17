#!/bin/bash

# Use Wofi to ask for the search query
query=$(wofi --dmenu --prompt "Search YouTube:")

# If query is empty, exit
if [ -z "$query" ]; then
  echo "No query provided. Exiting."
  exit 1
fi

# Run pipe-viewer with the search query, pipe the results to wofi for selection
selected_video=$(pipe-viewer "$query" | wofi --dmenu --prompt="Select Video:")

# If a video is selected, play it
if [ -n "$selected_video" ]; then
  # Use the first matching video from the list to play in mpv
  video_url=$(pipe-viewer "$query" | grep -i "$selected_video" | awk '{print $1}')
  mpv "$video_url"
else
  echo "No video selected. Exiting."
  exit 1
fi

