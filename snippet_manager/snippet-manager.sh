#!/bin/bash

# Configuration
SNIPPET_FILE="$HOME/Templates/snippets/snippets.csv" # Path to your snippets CSV file
# New delimiter
SNIPPET_DELIMITER="###"
FZF_DISPLAY_DELIMITER="::" # A consistent delimiter for fzf display, less likely to be in snippet_content

# Detect clipboard utility (retains previous robust detection)
CLIP_TOOL=""
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
  if command -v wl-copy &>/dev/null; then
    CLIP_TOOL="wl-copy"
  else
    echo "Warning: Wayland detected but wl-copy not found. Install wl-clipboard for copy functionality." >&2
  fi
elif command -v xclip &>/dev/null; then
  CLIP_TOOL="xclip -selection clipboard"
else
  echo "Warning: No suitable clipboard utility (wl-copy or xclip) found. Copy functionality will be disabled." >&2
fi

# Check if the snippet file exists
if [[ ! -f "$SNIPPET_FILE" ]]; then
  echo "Error: Snippet file '$SNIPPET_FILE' not found." >&2
  echo "Please create it with format: 'Snippet Name ### tags ### snippet content'" >&2
  exit 1
fi

# Fuzzy search and copy
select_and_copy_snippet() {
  if [[ -z "$CLIP_TOOL" ]]; then
    echo "Error: No clipboard tool available. Cannot copy snippet." >&2
    return 1
  fi

  local selected_line
  selected_line=$(
    # Use SNIPPET_DELIMITER for parsing the CSV file
    awk -F "$SNIPPET_DELIMITER" '
      {
        # Trim each field before printing
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", $3)
        print $1 " '"$FZF_DISPLAY_DELIMITER"' " $2 " '"$FZF_DISPLAY_DELIMITER"' " $3
      }
    ' "$SNIPPET_FILE" | fzf \
      --style default \
      --height 50% --layout reverse --border \
      --border-label ' Snippet Manager ' --input-label ' Input ' --preview-label ' Preview ' \
      --delimiter="$FZF_DISPLAY_DELIMITER" \
      --with-nth="1,2" \
      --info=inline \
      --bind 'result:transform-list-label:
          if [[ -z $FZF_QUERY ]]; then
            echo " $FZF_MATCH_COUNT items "
          else
            echo " $FZF_MATCH_COUNT matches for [$FZF_QUERY] "
          fi
          ' \
      --header="Select a snippet to copy (search by name or tags):" \
      --no-mouse \
      --preview-window=wrap \
      --preview "if [[ -f {3} && -s {3} ]]; then echo '--- Snippet in a File ---'; echo ''; cat {3}; elif [[ -f {3} && ! -s {3} ]]; then echo '--- Empty File ---'; echo ''; else echo '--- Snippet ---'; echo ''; echo {3} | head -c 200; fi" \
      --color 'border:#1e66f5, label:#1e66f5' \
      --color 'preview-border:#179299, preview-label:#179299' \
      --color 'list-border:#179299, list-label:#179299' \
      --color 'header-border:#d20f39' \
      --color 'input-border:#4c4f69, input-label:#4c4f69'
  )

  if [[ -n "$selected_line" ]]; then
    local snippet_content
    # Use FZF_DISPLAY_DELIMITER for parsing the line returned by fzf
    snippet_content=$(echo "$selected_line" | awk -F " *$FZF_DISPLAY_DELIMITER *" '{print $3}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')

    if [[ -n "$snippet_content" ]]; then
      # Check if snippet_content is a valid and non-empty file
      if [[ -f "$snippet_content" && -s "$snippet_content" ]]; then
        $CLIP_TOOL <"$snippet_content"
        echo "File content copied to clipboard."
      elif [[ -f "$snippet_content" && ! -s "$snippet_content" ]]; then
        # If the file exists but is empty, just print a message
        echo "Selected file is empty." >&2
      else
        # If not a file, process the snippet content
        # Check for '*' character anywhere in the snippet
        if [[ "$snippet_content" == *"*"* ]]; then
          echo "$snippet_content" | tr '*' '\n' | $CLIP_TOOL
          echo "Snippet content with '*' transformed to newlines copied to clipboard."
        else
          echo -n "$snippet_content" | $CLIP_TOOL
          echo "Snippet copied to clipboard."
        fi
      fi
    else
      echo "Selected line has no snippet content or parsing failed." >&2
    fi
  else
    echo "No snippet selected."
  fi
}
add_snippet() {
  read -rp "Enter Snippet Name: " name
  read -rp "Enter Tags (comma-separated): " tags
  read -rp "Enter Snippet Content or File Path: " content

  if [[ -z "$name" || -z "$content" ]]; then
    echo "Name and content cannot be empty. Aborting." >&2
    return 1
  fi

  echo "$name$SNIPPET_DELIMITER$tags$SNIPPET_DELIMITER$content" >>"$SNIPPET_FILE"
  echo "Snippet added."
}

# Edit snippets

edit_snippets_file() {
  if [[ -z "$EDITOR" ]]; then
    echo "EDITOR environment variable not set. Using 'nano'." >&2
    nano "$SNIPPET_FILE"
  else
    "$EDITOR" "$SNIPPET_FILE"
  fi
  echo "Snippets file opened for editing."
}

# Function to list unique tags
list_tags() {
  if [[ ! -f "$SNIPPET_FILE" ]]; then
    echo "Error: Snippet file '$SNIPPET_FILE' not found." >&2
    return 1
  fi

  awk -F "$SNIPPET_DELIMITER" '
    !/^#/ { # Ignore comment lines
      tags_field = $2
      # Remove leading/trailing spaces from the whole tags field
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", tags_field)

      # Split by comma and print each tag on a new line
      n = split(tags_field, tags_array, ",")
      for (i = 1; i <= n; i++) {
        # Trim leading/trailing spaces from individual tags
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", tags_array[i])
        if (tags_array[i] != "") { # Ensure tag is not empty after trimming
          print tags_array[i]
        }
      }
    }
  ' "$SNIPPET_FILE" | sort -u
}

# Help function
show_help() {
  echo "Usage: $(basename "$0") [command]"
  echo ""
  echo "Commands:"
  echo "  (no command)  : Launch fzf to select and copy a snippet."
  echo "  add           : Add new snippet interactively to snippets.csv."
  echo "  edit          : Edit snippets.csv using your default editor."
  echo "  tags          : List all unique tags used in snippets.csv."
  echo "  help          : Show this help message."
  echo ""
  echo "Snippet CSV file: $SNIPPET_FILE"
  echo "Location of other snippet files: $HOME/Templates/snippets/"
  echo "CSV format: 'Snippet Name${SNIPPET_DELIMITER}tag1,tag2${SNIPPET_DELIMITER}snippet content or file path'"
  echo "While creating a snippet use '*' instead of a newline character."
}

# Run functions - if empty argument, default to select and copy snippet
case "$1" in
add) add_snippet ;;
edit) edit_snippets_file ;;
help) show_help ;;
tags) list_tags ;;
"") select_and_copy_snippet ;; # no arguments provided
*)
  echo "Error: Unknown command '$1'" >&2
  show_help
  exit 1
  ;;
esac
