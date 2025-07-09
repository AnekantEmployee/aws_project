#!/bin/bash
yum update -y
yum install -y nodejs npm

# Install PM2 for process management
npm install -g pm2

# Create app directory if it doesn't exist
mkdir -p /var/www/html/nextjs-app
chown -R ec2-user:ec2-user /var/www/html/nextjs-app