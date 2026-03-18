#!/bin/bash
set -e

# Wait for Redis to be ready
echo "Waiting for Redis..."
until ruby -e "require 'socket'; TCPSocket.new(ENV.fetch('REDIS_HOST', 'redis'), ENV.fetch('REDIS_PORT', 6379).to_i)" 2>/dev/null; do
  sleep 1
done
echo "Redis is up."

# Remove stale pids
rm -f /app/tmp/pids/server.pid

exec "$@"
