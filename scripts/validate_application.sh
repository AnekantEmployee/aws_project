#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-validate.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Validating application deployment..."

# Wait for application to fully start
echo "Waiting for application to initialize..."
sleep 10

# Check if PM2 process exists and is running
echo "Checking PM2 process status..."
if ! pm2 describe nextjs_app >/dev/null 2>&1; then
    echo "ERROR: PM2 process 'nextjs_app' not found"
    echo "Available PM2 processes:"
    pm2 list || true
    exit 1
fi

# Get PM2 status with retry
for i in {1..5}; do
    PM2_STATUS=$(pm2 describe nextjs_app 2>/dev/null | grep -E "status.*:" | head -1 | awk '{print $NF}' | tr -d ',' || echo "unknown")
    echo "PM2 process status (attempt $i): $PM2_STATUS"
    
    if [ "$PM2_STATUS" = "online" ]; then
        break
    fi
    
    if [ $i -lt 5 ]; then
        echo "Waiting for PM2 process to come online..."
        sleep 5
    fi
done

if [ "$PM2_STATUS" != "online" ]; then
    echo "ERROR: Application not online - current status: $PM2_STATUS"
    echo "PM2 logs:"
    pm2 logs nextjs_app --lines 50 || true
    exit 1
fi

# Check if port 3000 is listening
echo "Checking if port 3000 is listening..."
for i in {1..10}; do
    if netstat -tuln | grep -q ":3000 "; then
        echo "✓ Port 3000 is listening"
        break
    fi
    
    if [ $i -eq 10 ]; then
        echo "ERROR: Port 3000 is not listening after 10 attempts"
        echo "Current listening ports:"
        netstat -tuln | grep LISTEN || true
        exit 1
    fi
    
    echo "Waiting for port 3000 to be available (attempt $i/10)..."
    sleep 3
done

# Health check with retries and exponential backoff
echo "Performing health checks..."
MAX_ATTEMPTS=15
TIMEOUT=10

for i in $(seq 1 $MAX_ATTEMPTS); do
    echo "Health check attempt $i/$MAX_ATTEMPTS (timeout: ${TIMEOUT}s)..."
    
    # Try to connect to the application
    if curl -s --max-time $TIMEOUT --connect-timeout 5 -o /dev/null -w "%{http_code}" http://localhost:3000/ | grep -q "200\|301\|302"; then
        echo "✓ Application is responding on port 3000"
        
        # Additional health check if /api/health exists
        HEALTH_STATUS=$(curl -s --max-time $TIMEOUT --connect-timeout 5 -o /dev/null -w "%{http_code}" http://localhost:3000/api/health 2>/dev/null || echo "404")
        if [ "$HEALTH_STATUS" = "200" ]; then
            echo "✓ Health endpoint is responding"
        else
            echo "ℹ Health endpoint not available (this is okay if not implemented)"
        fi
        
        echo "✓ Application validation successful"
        echo "Final PM2 status:"
        pm2 status
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