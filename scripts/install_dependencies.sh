#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-install-deps.log) 2>&1

echo "Starting dependency installation..."

cd /var/www/nextjs_app

# Check if package.json exists
if [ ! -f package.json ]; then
    echo "ERROR: package.json not found in $(pwd)"
    echo "Directory contents:"
    ls -la
    exit 1
fi

echo "Found package.json. Installing dependencies..."

# Install production dependencies only
npm ci --only=production

echo "Dependencies installed successfully"