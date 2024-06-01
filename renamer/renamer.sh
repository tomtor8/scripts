#!/usr/bin/env bash

# get current working directory
directory=$(pwd)

for file in "$directory"/*; do
  if [ -f "$file" ]; then
    oldbasename=$(basename "$file")
    # here add verbose if condition
    echo "Processing file: ${oldbasename}"
    # translate characters underscore and space to dash
    newbasename=$(basename "$file" | tr "_ " "--")
    # renaming the file
    mv "$file" "$directory$newbasename"
    # here add verbose if condition
    echo "Renamed ${oldbasename} to ${newbasename}"
  fi
done
