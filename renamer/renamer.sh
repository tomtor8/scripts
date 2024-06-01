#!/usr/bin/env bash

# get current working directory
directory=$(pwd)

# the first colon before options supresses error messages - here we do not use it
# d option has arguments - directory path
# c option for lower-casing the text

while getopts cd: opt; do
  case "$opt" in
  c)
    c_option=1
    ;;
  d)
    # OPTARG is the option argument in this case dir name
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

# # if you use renamer.sh -d /path/to/dir firstarg secondarg
# shift $((OPTIND - 1))

# echo "First argument after options is $1"
# echo "Second argument after options is $2"

for file in "$directory"/*; do
  if [ -f "$file" ]; then
    oldbasename=$(basename "$file")
    # check if basename contains space or underscore or capital letters
    if [[ "$c_option" -eq 1 ]]; then
      if [[ "$oldbasename" == *[_\ ]* ]] || [[ "$oldbasename" == *[A-Z]* ]]; then
        # here add verbose if condition
        echo "Processing file: ${oldbasename}"
        # translate characters underscore and space to dash then from uppercase to lowercase
        newbasename=$(basename "$file" | tr "_ " "--" | tr "[:upper:]" "[:lower:]")
        # renaming the file
        mv "$file" "${directory}/${newbasename}"
        # here add verbose if condition
        echo "Renamed ${oldbasename} to ${newbasename}"
      else
        echo "File ${oldbasename} does not need to be renamed."
      fi
    else
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
  fi
done
