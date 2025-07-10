#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-stop.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Stopping application..."

# Don't fail if PM2 process doesn't exist
set +e

# Check if PM2 process exists
if pm2 describe nextjs_app >/dev/null 2>&1; then
    echo "Stopping nextjs_app process..."
    pm2 stop nextjs_app
    
    echo "Deleting nextjs_app process..."
    pm2 delete nextjs_app
    
    echo "Saving PM2 process list..."
    pm2 save
else
    echo "No nextjs_app process found to stop"
fi

# Kill any remaining node processes on port 3000
PIDS=$(lsof -t -i:3000 2>/dev/null || echo "")
if [ -n "$PIDS" ]; then
    echo "Killing remaining processes on port 3000: $PIDS"
    kill -9 $PIDS || true
fi

set -e

echo "Application stopped successfully"