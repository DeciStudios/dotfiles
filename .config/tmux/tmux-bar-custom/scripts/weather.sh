#!/usr/bin/env bash

# Default location if not set
LOCATION="${1:-Swindon}"

# Fetch weather from wttr.in
curl -s "wttr.in/${LOCATION}?format=%c+%t"
