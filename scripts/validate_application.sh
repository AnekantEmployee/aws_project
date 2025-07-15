#!/bin/bash
set -euo pipefail

echo "Validating Next.js service..."
sleep 30

if sudo -u ubuntu pm2 list | grep -q "nextjs-app.*online"; then
  echo "PM2 process is running"
else
  echo "PM2 process is not running"
  exit 1
fi

if curl -f -s http://localhost:3000 >/dev/null; then
  echo "Application is responding to HTTP requests"
else
  echo "Application is not responding to HTTP requests"
  exit 1
fi