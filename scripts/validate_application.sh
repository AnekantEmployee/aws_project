# scripts/validate_service.sh
#!/bin/bash
set -e

echo "Validating Next.js service..."

# Wait for application to start
sleep 30

# Check if the application is running
if sudo -u ubuntu pm2 list | grep -q "nextjs-app.*online"; then
    echo "PM2 process is running"
else
    echo "PM2 process is not running"
    exit 1
fi

# Check if application responds to HTTP requests
if curl -f -s http://localhost:3000 > /dev/null; then
    echo "Application is responding to HTTP requests"
    echo "Deployment successful!"
else
    echo "Application is not responding to HTTP requests"
    exit 1
fi