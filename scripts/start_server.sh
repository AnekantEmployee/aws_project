#!/bin/bash
cd /var/www/html/nextjs-app

# Install dependencies
npm ci

# Build the application
npm run build

# Start the application with PM2
pm2 stop nextjs-app || true
pm2 start npm --name "nextjs-app" -- start
pm2 save