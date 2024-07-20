#!/usr/bin/env bash

ensourcefl="/home/tom/Documents/databases/en-sk-dict.db"
entargetfl="/run/media/tom/AudioCard/databases_bak/en-sk-dict-bak.db"
husourcefl="/home/tom/Documents/databases/hu-sk-dict.db"
hutargetfl="/run/media/tom/AudioCard/databases_bak/hu-sk-dict-bak.db"
booksourcefl="/home/tom/Documents/databases/my-books.db"
booktargetfl="/run/media/tom/AudioCard/databases_bak/my-books-bak.db"
pswdsourcefl="/home/tom/Documents/english/t_pswd.kdbx"
pswdtargetfl="/run/media/tom/AudioCard/databases_bak/t_pswd-bak.kdbx"

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

if [[ ! -d /run/media/tom/AudioCard/databases_bak ]]; then
  echo "The local_backups directory does not exist."
  if mkdir /run/media/tom/AudioCard/databases_bak; then
    echo "Created /run/media/tom/AudioCard/databases_bak directory."
  else
    echo "Can not create databases_bak directory, probably your AudioCard is not inserted."
    exit 1
  fi
fi

# check if source files exist
if [[ -f "$ensourcefl" ]]; then
  # english slovak database backup
  if backup_is_older "$ensourcefl" "$entargetfl"; then
    sqlite3 "$ensourcefl" ".backup ${entargetfl}"
    echo "en-sk-dict.db backed up in the databases_bak directory on AudioCard"
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
    echo "hu-sk-dict.db backed up in the databases_bak directory on AudioCard"
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
    echo "my-books.db backed up in the databases_bak directory on AudioCard"
  else
    echo "Backup of the file my-books.db is not necessary."
  fi
else
  echo "${booksourcefl} does not exist!"
fi

if [[ -f "$pswdsourcefl" ]]; then
  if backup_is_older "$pswdsourcefl" "$pswdtargetfl"; then
    cp -u "$pswdsourcefl" "$pswdtargetfl"
    echo "t_pswd.kdbx backed up in the databases_bak directory on AudioCard"
  else
    echo "Backup of the file t_pswd.kdbx is not necessary."
  fi
else
  echo "${pswdsourcefl} does not exist!"
fi
