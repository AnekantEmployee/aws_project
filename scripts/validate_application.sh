#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-validate.log) 2>&1

echo "Validating application..."

# Wait for application to fully start
sleep 15

# Check if PM2 process is running
if pm2 describe nextjs_app | grep -q "online"; then
    echo "Application is running successfully"
    
    # Test HTTP endpoint with retry logic
    for i in {1..5}; do
        if curl -s --max-time 10 http://localhost:3000 > /dev/null; then
            echo "Application is responding to HTTP requests"
            echo "Validation completed successfully"
            exit 0
        else
            echo "Attempt $i: Application not yet responding, waiting..."
            sleep 5
        fi
    done
    
    echo "Application is not responding to HTTP requests after 5 attempts"
    exit 1
else
    echo "Application failed to start"
    pm2 logs nextjs_app --lines 50
    exit 1
fi