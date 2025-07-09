#!/bin/bash
apt update -y
apt install -y nodejs npm

# Install PM2 for process management
npm install -g pm2

# Create app directory if it doesn't exist
mkdir -p /var/www/html/nextjs-app
chown -R ubuntu:ubuntu /var/www/html/nextjs-app