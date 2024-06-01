#!/usr/bin/env bash

# get current working directory
directory=$(pwd)

# the first colon supresses error messages
# d option has arguments - directory path
# c option for lower-casing the text

while getopts cd: opt; do
  case "$opt" in
  c) echo "Found the -c option" ;;
  d)
    echo "Found the -d option with parameter value $OPTARG"
    if [[ -d "$OPTARG" ]]; then
      directory="$OPTARG"
    else
      echo "Directory does not exist. Exiting."
      exit 1
    fi
    ;;
  *)
    echo "Unknown option: $opt"
    exit 1
    ;;
  esac
done

# shift $((OPTIND - 1))

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
