#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-install-deps.log"
exec > >(tee "$LOG_FILE") 2>&1

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

# Set proper npm registry and clear cache
npm config set registry https://registry.npmjs.org/
npm cache clean --force

# Install dependencies
echo "Installing production dependencies..."
npm ci --only=production --no-optional

echo "Dependencies installed successfully"

# Show installed packages for debugging
echo "Installed packages:"
npm list --depth=0 || true