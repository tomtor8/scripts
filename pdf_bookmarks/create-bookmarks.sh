#!/bin/bash

# Script to transform an input file into a new file with a modified name for pdftk-java bookmarks.
# It also trims leading/trailing spaces/tabs from fields and line ends.
# Usage: ./create_bookmarks.sh <input_filename>

# Check if an input filename is provided as an argument
if [[ -z "$1" ]]; then
    echo "Usage: $0 <input_filename>"
    echo "Error: No input file specified."
    exit 1
fi

input_file="$1" # Store the first command-line argument as the input file

# Check if the specified input file exists
if [[ ! -f "$input_file" ]]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Extract the base name of the input file (without directory path)
base_name=$(basename -- "$input_file")

# Remove the extension from the base name
# This handles cases with multiple dots in the filename (e.g., "my.book.txt")
file_name_without_ext="${base_name%.*}"

# Construct the output filename
output_file="${file_name_without_ext}-processed.txt"

# Process the input file and generate the new output file
awk -F'|' '
    # Trim leading/trailing whitespace (spaces and tabs) from the entire line before processing fields
    {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
    }

    # Process lines that are not comments and have exactly 3 fields after potential trimming
    !/^#/ && NF == 3 {
        # Trim leading/trailing whitespace from each field
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3)

        print "BookmarkBegin"
        print "BookmarkTitle: " $3
        print "BookmarkLevel: " $1
        print "BookmarkPageNumber: " $2
    }
' "$input_file" > "$output_file"

echo "Transformation complete. '$output_file' has been created from '$input_file'."
