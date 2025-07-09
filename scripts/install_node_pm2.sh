#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-install-node.log) 2>&1

echo "Installing Node.js and PM2..."

# Update package manager
apt-get update

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

# Create directory and set permissions
mkdir -p /var/www/nextjs_app
chown -R root:root /var/www/nextjs_app

echo "Node.js and PM2 installation completed"