# scripts/stop_application.sh
#!/bin/bash
set -e

echo "Stopping Next.js application..."

# Check if PM2 is running and stop the application
if command -v pm2 &> /dev/null; then
    if sudo -u ubuntu pm2 list | grep -q "nextjs-app"; then
        sudo -u ubuntu pm2 stop nextjs-app || true
        sudo -u ubuntu pm2 delete nextjs-app || true
    fi
fi

# Kill any remaining Node.js processes on port 3000
sudo pkill -f "node.*3000" || true

echo "Application stopped!"