#!/usr/bin/env bash

# get current working directory
directory=$(pwd)

for file in "$directory"/*; do
  if [ -f "$file" ]; then
    oldbasename=$(basename "$file")
    # check if basename contains space or underscore
    if [[ "$oldbasename" == *[_\ ]* ]]; then
      # here add verbose if condition
      echo "Processing file: ${oldbasename}"
      # translate characters underscore and space to dash
      newbasename=$(basename "$file" | tr "_ " "--")
      # renaming the file

      mv "$file" "${directory}/${newbasename}"
      # here add verbose if condition
      echo "Renamed ${oldbasename} to ${newbasename}"
    else
      echo "File ${oldbasename} does not need to be renamed."
    fi
  fi
done
