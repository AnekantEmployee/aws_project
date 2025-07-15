#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/nextjs-app"
LOG_FILE="/var/log/codedeploy-nextjs.log"

exec > >(tee -a "$LOG_FILE") 2>&1
echo "[$(date)]  --- AfterInstall start ---"

# 1. Ensure Node 18
if ! command -v node &>/dev/null || [[ "$(node -v | cut -d. -f1)" != "v18" ]]; then
  echo "-- Installing Node 18 --"
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt-get install -y nodejs
fi

# 2. Ensure PM2
if ! command -v pm2 &>/dev/null; then
  echo "-- Installing PM2 globally --"
  npm install -g pm2@latest
fi

# 3. Dependencies
cd "$APP_DIR"
rm -f package-lock.json           # forces fresh resolution
npm ci --omit=dev --no-audit --no-fund --progress=false

# 4. Build
echo "-- Building Next.js --"
npm run build

# 5. Permissions
chown -R ubuntu:ubuntu "$APP_DIR"

echo "[$(date)]  --- AfterInstall end ---"