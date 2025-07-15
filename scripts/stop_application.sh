#!/bin/bash
set -euo pipefail

echo "Stopping Next.js application..."

if command -v pm2 &>/dev/null; then
  sudo -u ubuntu pm2 stop nextjs-app || true
  sudo -u ubuntu pm2 delete nextjs-app || true
fi

sudo pkill -f "node.*3000" || true
echo "Application stopped!"