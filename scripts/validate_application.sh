#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-validate.log) 2>&1

echo "Validating application..."

cd /var/www/nextjs_app

# Start the application with PM2
pm2 start npm --name "nextjs_app" -- start

# Wait for application to start
sleep 10

# Check if application is running
if pm2 describe nextjs_app | grep -q "online"; then
    echo "Application is running successfully"
    
    # Test HTTP endpoint
    if curl -s http://localhost:3000 > /dev/null; then
        echo "Application is responding to HTTP requests"
    else
        echo "Application is not responding to HTTP requests"
        exit 1
    fi
else
    echo "Application failed to start"
    exit 1
fi

echo "Validation completed successfully"