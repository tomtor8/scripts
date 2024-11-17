#!/usr/bin/env bash

# Change to your desired directory or use a specific path
DIRECTORY="$HOME/Documents" # Adjust this to your PDF directory

# Use fzf to select a PDF file from the specified directory
file=$(find "$DIRECTORY" -type f -name "*.pdf" | fzf)

# Check if a file was selected
if [ -n "$file" ]; then
  xdg-open "$file" &
else
  echo "No file selected."
fi
