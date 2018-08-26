#!/bin/bash
set -e

if [ -z "$(ls -A /app)" ]; then
  echo "App directory empty - copying files..."
  cp -r /project/. /app/
  cp -f /overrides/build.properties /app
else
  echo "App directory populated - skipping copy."
fi

# Command exec
echo Entrypoint executing: "$@"
exec "$@"