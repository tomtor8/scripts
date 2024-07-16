#!/usr/bin/env bash

if [[ ! -d /home/tom/Documents/local_backups ]]; then
  echo "The local_backups directory does not exist, creating one."
  mkdir /home/tom/Documents/local_backups
fi

if [[ -f /home/tom/Documents/english/en-sk-dict.db ]]; then
  sqlite3 /home/tom/Documents/english/en-sk-dict.db ".backup /home/tom/Documents/local_backups/en-sk-dict-bak.db"
  echo "File en-sk-dict.db backed up in the local_backups directory."
else
  echo "Could not find the en-sk-dict.db file in Documents/english directory."
fi

if [[ -f /home/tom/Documents/english/hu-sk-dict.db ]]; then
  sqlite3 /home/tom/Documents/english/hu-sk-dict.db ".backup /home/tom/Documents/local_backups/hu-sk-dict-bak.db"
  echo "File hu-sk-dict.db backed up in the local_backups directory."
else
  echo "Could not find the hu-sk-dict.db file in Documents/english directory."
fi

if [[ -f /home/tom/Documents/english/my-books.db ]]; then
  sqlite3 /home/tom/Documents/english/my-books.db ".backup /home/tom/Documents/local_backups/my-books-bak.db"
  echo "File my-books.db backed up in the local_backups directory."
else
  echo "Could not find the my-books.db file in Documents/english directory."
fi
