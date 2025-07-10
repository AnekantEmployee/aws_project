#!/bin/bash
set -e

exec > >(tee /var/log/codedeploy-start.log) 2>&1

echo "Starting application..."
cd /var/www/nextjs_app

# Environment setup
export NODE_ENV=production
export PORT=3000
export HOST=0.0.0.0

# Start application
echo "Starting Next.js server..."
pm2 start npm --name "nextjs_app" -- start -- -H $HOST -p $PORT

# Save PM2 process list
pm2 save

# Ensure PM2 starts on reboot
pm2 startup | bash

echo "Application started successfully"