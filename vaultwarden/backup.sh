#!/bin/bash

if /usr/bin/docker exec -i vaultwarden /vaultwarden backup; then
  echo "Successfully backed up database"
else
  echo "Error backing up database" >&2
  exit 1
fi

if mv /apps/vaultwarden/db_*.sqlite3 /mnt/backup-02/backup/vaultwarden/; then
  echo "Successfully moved database to backup directory"
else
  echo "Error moving database" >&2
  exit 1
fi

exit 0
