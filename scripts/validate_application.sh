#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-validate.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Validating application deployment..."

# Wait for application to fully start
echo "Waiting for application to initialize..."
sleep 15

# Check if PM2 process exists and is running
echo "Checking PM2 process status..."
if ! pm2 describe nextjs_app >/dev/null 2>&1; then
    echo "ERROR: PM2 process 'nextjs_app' not found"
    echo "Available PM2 processes:"
    pm2 list || true
    exit 1
fi

# Get PM2 status
PM2_STATUS=$(pm2 describe nextjs_app 2>/dev/null | grep -E "status.*:" | head -1 | awk '{print $NF}' | tr -d ',' || echo "unknown")

echo "PM2 process status: $PM2_STATUS"

if [ "$PM2_STATUS" != "online" ]; then
    echo "ERROR: Application not online - current status: $PM2_STATUS"
    echo "PM2 logs:"
    pm2 logs nextjs_app --lines 50 || true
    exit 1
fi

# Check if port 3000 is listening
echo "Checking if port 3000 is listening..."
if ! netstat -tuln | grep -q ":3000 "; then
    echo "ERROR: Port 3000 is not listening"
    echo "Current listening ports:"
    netstat -tuln | grep LISTEN || true
    exit 1
fi

# Health check with retries and exponential backoff
echo "Performing health checks..."
MAX_ATTEMPTS=12
TIMEOUT=5

for i in $(seq 1 $MAX_ATTEMPTS); do
    echo "Health check attempt $i/$MAX_ATTEMPTS (timeout: ${TIMEOUT}s)..."
    
    # Try to connect to the application
    if curl -s --max-time $TIMEOUT --connect-timeout 3 http://localhost:3000/ >/dev/null 2>&1; then
        echo "✓ Application is responding on port 3000"
        
        # Additional health check if /api/health exists
        if curl -s --max-time $TIMEOUT --connect-timeout 3 http://localhost:3000/api/health >/dev/null 2>&1; then
            echo "✓ Health endpoint is responding"
        else
            echo "ℹ Health endpoint not available (this is okay if not implemented)"
        fi
        
        echo "✓ Application validation successful"
        exit 0
    fi
    
    # Exponential backoff
    SLEEP_TIME=$((2 ** (i - 1)))
    if [ $SLEEP_TIME -gt 30 ]; then
        SLEEP_TIME=30
    fi
    
    if [ $i -lt $MAX_ATTEMPTS ]; then
        echo "Attempt failed, retrying in ${SLEEP_TIME}s..."
        sleep $SLEEP_TIME
    fi
done

echo "ERROR: Application validation failed after $MAX_ATTEMPTS attempts"
echo "Final PM2 status:"
pm2 status || true
echo "Recent PM2 logs:"
pm2 logs nextjs_app --lines 50 || true
echo "System resources:"
free -h || true
df -h || true

exit 1