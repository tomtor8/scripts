#!/usr/bin/env bash

# Set the directory to iterate through
directory="$HOME/Pictures/Screenshots"
# output file for scanned text
outputfile="$HOME/Pictures/Screenshots/scanned-text.txt"
# date and time
date_time=$(date -u +%Y-%m-%d\ at\ %H:%M)

# use text block with cat
message=$(
  cat <<EOF
-----------------------------------
Date and time of the OCR operation:
$date_time
-----------------------------------
EOF
)

add_header() {
  # using so called brace group to append more lines to the file
  {
    echo "$message"
    echo -e "\n"
  } >>"$outputfile"
}

if [ ! -d "$directory" ]; then
  echo "The directory Screenshots does not exist"
  exit 1
fi

# check if a scanned-text.txt file exists

if [ -f "$outputfile" ]; then
  echo "The scanned-text.txt already exists."
  read -r -p "Do you wish to overwrite it? (y/n)" answer
  if [ "$answer" == "y" ]; then
    # clear the content of the outputfile
    cat /dev/null >"$outputfile"
    echo "The file was cleaned."
  else
    echo "The scanned text will be added to the existing file."
  fi
else
  echo "Creating scanned-text.txt file!"
fi

add_header

# Iterate through the files in the directory
for file in "$directory"/*.{jpeg,jpg,png}; do
  if [ -f "$file" ]; then
    echo "Processing file: $file"
    # OCR the file to stdout and replace newline chars with spaces
    # then append to scanned-text.txt
    tesseract "$file" - -l eng+spa | tr "\n" " " >>"$outputfile"
    # append new line after the section
    # -e flag enables using escape characters
    echo -e "\n" >>"$outputfile"
  fi
done

echo "Finished!"
echo -e "\n"

read -r -p "Do you wish to copy the text to clipboard or open the file or nothing? (c/o/n)" reply
if [ "$reply" == "c" ]; then
  if [ -f "$outputfile" ]; then
    # put the text to system clipboard
    wl-copy <"$outputfile"
    echo "Text copied to the system clipboard!"
  else
    echo "The output file does not exist!"
    exit 1
  fi
elif [ "$reply" == "o" ]; then
  xdg-open "$outputfile" &
else
  echo "Doing nothing! Bye!"
  exit 0
fi
