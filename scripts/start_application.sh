#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/nextjs-app"

cd "$APP_DIR"

# Stop & delete any existing PM2 instance (in case of redeploy)
sudo -u ubuntu pm2 delete nextjs-app || true

# Start
sudo -u ubuntu pm2 start ecosystem.config.js --env production
sudo -u ubuntu pm2 save

# Enable auto-start only once
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu --service-name pm2-nextjs || true

echo "Application started with PM2"