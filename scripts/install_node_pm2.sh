#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-install-node.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Installing Node.js and PM2..."

# Update package manager
apt-get update

# Install curl if not present
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    apt-get install -y curl
fi

# Install Node.js LTS if not present or wrong version
REQUIRED_NODE_VERSION="18"
if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing Node.js $REQUIRED_NODE_VERSION..."
    curl -fsSL https://deb.nodesource.com/setup_${REQUIRED_NODE_VERSION}.x | bash -
    apt-get install -y nodejs
else
    CURRENT_NODE_VERSION=$(node --version | cut -d'.' -f1 | sed 's/v//')
    if [ "$CURRENT_NODE_VERSION" != "$REQUIRED_NODE_VERSION" ]; then
        echo "Node.js version $CURRENT_NODE_VERSION found, updating to $REQUIRED_NODE_VERSION..."
        curl -fsSL https://deb.nodesource.com/setup_${REQUIRED_NODE_VERSION}.x | bash -
        apt-get install -y nodejs
    fi
fi

# Install PM2 globally if not present
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2@latest
else
    echo "PM2 already installed, updating..."
    npm update -g pm2
fi

# Create directory and set proper permissions
mkdir -p /var/www/nextjs_app
chown -R ubuntu:ubuntu /var/www/nextjs_app

echo "Node.js $(node --version) and PM2 $(pm2 --version) installation completed"