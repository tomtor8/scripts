#!/bin/bash

# Configuration
SNIPPET_FILE="$HOME/.local/share/snippets/snippets.csv" # Path to your snippets CSV file
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
    awk -F "$SNIPPET_DELIMITER" '{print $1 " '"$FZF_DISPLAY_DELIMITER"' " $2 " '"$FZF_DISPLAY_DELIMITER"' " $3}' "$SNIPPET_FILE" | fzf \
      --delimiter="$FZF_DISPLAY_DELIMITER" \
      --with-nth="1,2" \
      --layout=reverse \
      --info=inline \
      --header="Select a snippet to copy (search by name or tags):" \
      --no-mouse \
      --preview "echo '--- Snippet ---'; echo ''; echo {3} | head -c 200"
  )

  if [[ -n "$selected_line" ]]; then
    local snippet_content
    # Use FZF_DISPLAY_DELIMITER for parsing the line returned by fzf
    snippet_content=$(echo "$selected_line" | awk -F " *$FZF_DISPLAY_DELIMITER *" '{print $3}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')

    if [[ -n "$snippet_content" ]]; then
      echo -n "$snippet_content" | $CLIP_TOOL
      echo "Snippet copied to clipboard."
    else
      echo "Selected line has no snippet content or parsing failed." >&2
    fi
  else
    echo "No snippet selected."
  fi
}

# Run the function
select_and_copy_snippet
