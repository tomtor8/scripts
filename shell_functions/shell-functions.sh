# delete braces {sometext} and any text inside
# throughout the text copied from clipboard
# then copy it back to clipboard
# eg. `Text with { some text } is here.` changes to
# `Text with is here.`

delbraces() {
  wl-paste | sed -e ':a' -e 's/{[^}]*}//g' -e 't a' -e 'P' -e 'd' | wl-copy && echo "Successfully transformed text and copied back to clipboard!" || echo "Something went wrong!!"
}
