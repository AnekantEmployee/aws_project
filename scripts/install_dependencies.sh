#!/bin/bash
set -e  # Exit on any error

# Log output
exec > >(tee /var/log/codedeploy-install.log) 2>&1

echo "Starting dependency installation..."

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt-get install -y nodejs
fi

# Install PM2 globally if not present
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Create directory if it doesn't exist
mkdir -p /var/www/nextjs_app
cd /var/www/nextjs_app

# Install dependencies
if [ -f package.json ]; then
    echo "Installing npm dependencies..."
    npm install --omit=dev
else
    echo "package.json not found!"
    exit 1
fi

echo "Dependencies installed successfully"