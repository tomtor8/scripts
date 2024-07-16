#!/usr/bin/env bash

ensourcefl="/home/tom/Documents/english/en-sk-dict.db"
entargetfl="/home/tom/Documents/local_backups/en-sk-dict-bak.db"
husourcefl="/home/tom/Documents/english/hu-sk-dict.db"
hutargetfl="/home/tom/Documents/local_backups/hu-sk-dict-bak.db"
booksourcefl="/home/tom/Documents/english/my-books.db"
booktargetfl="/home/tom/Documents/local_backups/my-books-bak.db"
pswdsourcefl="/home/tom/Documents/english/t_pswd.kdbx"
pswdtargetfl="/home/tom/Documents/local_backups/t_pswd-bak.kdbx"

# check modification times of db files
function backup_is_older() {
  local source_file=$1
  local target_file=$2
  local source_mtime
  source_mtime=$(stat -c %Y "$source_file")
  local target_mtime
  if [[ -f "$target_file" ]]; then
    target_mtime=$(stat -c %Y "$target_file")
  else
    # if target file does not exist time is 0
    target_mtime=0
  fi
  # local diff_secs=$((target_mtime - source_mtime))
  # check if source is newer than target
  if [[ $source_mtime -gt $target_mtime ]]; then
    return 0
  else
    return 1
  fi
}

if [[ ! -d /home/tom/Documents/local_backups ]]; then
  echo "The local_backups directory does not exist, creating one."
  mkdir /home/tom/Documents/local_backups
fi

# check if source files exist
if [[ -f "$ensourcefl" ]]; then
  # english slovak database backup
  if backup_is_older "$ensourcefl" "$entargetfl"; then
    sqlite3 "$ensourcefl" ".backup ${entargetfl}"
    echo "File en-sk-dict.db backed up in the local_backups directory."
  else
    echo "Backup of the file en-sk-dict.db is not necessary."
  fi
else
  echo "${ensourcefl} does not exist!"
fi

if [[ -f "$husourcefl" ]]; then
  # hungarian slovak database backup
  if backup_is_older "$husourcefl" "$hutargetfl"; then
    sqlite3 "$husourcefl" ".backup ${hutargetfl}"
    echo "File hu-sk-dict.db backed up in the local_backups directory."
  else
    echo "Backup of the file hu-sk-dict.db is not necessary."
  fi
else
  echo "${husourcefl} does not exist!"
fi

if [[ -f "$booksourcefl" ]]; then
  # my books database backup
  if backup_is_older "$booksourcefl" "$booktargetfl"; then
    sqlite3 "$booksourcefl" ".backup ${booktargetfl}"
    echo "File my-books.db backed up in the local_backups directory."
  else
    echo "Backup of the file my-books.db is not necessary."
  fi
else
  echo "${booksourcefl} does not exist!"
fi

if [[ -f "$pswdsourcefl" ]]; then
  if backup_is_older "$pswdsourcefl" "$pswdtargetfl"; then
    cp -u "$pswdsourcefl" "$pswdtargetfl"
    echo "File t_pswd.kdbx backed up in the local_backups directory if ."
  else
    echo "Backup of the file t_pswd.kdbx is not necessary."
  fi
else
  echo "${pswdsourcefl} does not exist!"
fi
