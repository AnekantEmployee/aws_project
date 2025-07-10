#!/bin/bash
set -e

# Use a log file in a writable location
LOG_FILE="/tmp/codedeploy-validate.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Validating application..."

# Extended timeout for Next.js cold starts
sleep 30

# Check PM2 status with better error handling
if ! pm2 describe nextjs_app >/dev/null 2>&1; then
    echo "PM2 process not found"
    pm2 list || true
    exit 1
fi

# Get PM2 status without using jq (parse the output differently)
PM2_STATUS=$(pm2 describe nextjs_app 2>/dev/null | grep -i "status" | head -1 | awk '{print $NF}' || echo "unknown")

if [ "$PM2_STATUS" != "online" ]; then
    echo "Application not online - current status: $PM2_STATUS"
    pm2 logs nextjs_app --lines 100 || true
    exit 1
fi

# Health check with retries and backoff
for i in {1..10}; do
    TIMEOUT=$((i * 2))
    echo "Attempt $i: Testing endpoint (timeout: ${TIMEOUT}s)..."
    
    if curl -s --max-time $TIMEOUT http://localhost:3000/api/health >/dev/null 2>&1; then
        echo "Application is healthy"
        exit 0
    fi
    
    sleep $TIMEOUT
done

echo "Validation failed - application not responding"
pm2 logs nextjs_app --lines 100 || true
exit 1