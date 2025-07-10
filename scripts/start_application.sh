#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-start.log) 2>&1

echo "Starting application..."

cd /var/www/nextjs_app

# Check if .next directory exists (build output)
if [ ! -d ".next" ]; then
    echo "ERROR: .next directory not found. Application may not be built."
    echo "Directory contents:"
    ls -la
    exit 1
fi

# Start the application with PM2 and bind to all interfaces
if [ -f "ecosystem.config.js" ]; then
    echo "Using PM2 ecosystem config"
    pm2 start ecosystem.config.js
else
    echo "Starting with inline PM2 configuration"
    pm2 start npm --name "nextjs_app" -- start -- -H 0.0.0.0 -p 3000
fi

echo "Application started successfully"