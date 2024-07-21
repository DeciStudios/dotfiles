#!/bin/bash

# Ensure the file argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

file="$1"

# Resolve the absolute path of the file
abs_path=$(realpath "$file")

# Get the directory of the file
dir=$(dirname "$abs_path")

# Modify the filename
base=$(basename "$file" | sed -e 's/\(\.[a-zA-Z]*\)/1\1/g')


# Create the symlink
ln -s "$abs_path" "$dir/$base"
