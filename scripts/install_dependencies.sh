#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/nextjs-app"
LOG_FILE="/var/log/codedeploy-nextjs.log"

exec > >(tee -a "$LOG_FILE") 2>&1
echo "[$(date)]  --- AfterInstall start ---"

# 1. Node 18
if ! command -v node &>/dev/null || [[ "$(node -v | cut -d. -f1)" != "v18" ]]; then
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  apt-get install -y nodejs
fi

# 2. PM2
if ! command -v pm2 &>/dev/null; then
  npm install -g pm2@latest
fi

# 3. Dependencies
cd "$APP_DIR"

# If lock file is missing, create it (fallback to npm install)
if [[ ! -f package-lock.json ]]; then
  echo "package-lock.json missing – running 'npm install' to create it"
  npm install --omit=dev --no-audit --no-fund
else
  echo "package-lock.json found – running 'npm ci'"
  npm ci --omit=dev --no-audit --no-fund
fi

# 4. Build
echo "-- Building Next.js --"
npm run build

# 5. Permissions
chown -R ubuntu:ubuntu "$APP_DIR"
echo "[$(date)]  --- AfterInstall end ---"