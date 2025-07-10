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

# Clear npm cache and install
npm cache clean --force
npm ci --only=production --no-optional

echo "Dependencies installed successfully"