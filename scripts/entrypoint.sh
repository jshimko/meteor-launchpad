#!/bin/bash

set -e

# set default port if is isn't set
export PORT=${PORT:-80}

# Set a delay to wait to start meteor container
if [[ $DELAY ]]; then
  echo "Delaying startup for $DELAY seconds"
  sleep $DELAY
fi


# Start app
echo "=> Starting app on port $PORT..."
exec "$@"
