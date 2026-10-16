#!/bin/sh
# Applies every .sql file in /migrations once, in filename order, each in a transaction.
# Applied files are recorded in schema_migrations and are not run again.
set -e
export PGPASSWORD="${PGPASSWORD:-trials}"
HOST="${PGHOST:-db}"
PSQL="psql -h $HOST -U trials -d trials -v ON_ERROR_STOP=1 -q"

$PSQL -c "CREATE TABLE IF NOT EXISTS schema_migrations (name TEXT PRIMARY KEY, applied_at TIMESTAMPTZ NOT NULL DEFAULT now())"

for f in $(ls /migrations/*.sql 2>/dev/null | sort); do
  name=$(basename "$f")
  applied=$($PSQL -tAc "SELECT 1 FROM schema_migrations WHERE name = '$name'")
  if [ -z "$applied" ]; then
    echo "applying $name"
    { echo "BEGIN;"; cat "$f"; echo; echo "INSERT INTO schema_migrations (name) VALUES ('$name');"; echo "COMMIT;"; } | $PSQL
  fi
done
echo "migrations up to date"
