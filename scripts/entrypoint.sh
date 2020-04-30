#!/bin/bash
set -e

# Command exec
echo Entrypoint executing: "$@"
exec "$@"
