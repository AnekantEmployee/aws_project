#!/bin/bash
set -e

exec > >(tee /var/log/codedeploy-validate.log) 2>&1

echo "Validating application..."

# Extended timeout for Next.js cold starts
sleep 30

# Check PM2 status with better error handling
if ! pm2 describe nextjs_app >/dev/null 2>&1; then
    echo "PM2 process not found"
    pm2 list
    exit 1
fi

# Get actual status (not just grep)
STATUS=$(pm2 jlist | jq -r '.[] | select(.name=="nextjs_app") | .pm2_env.status')
if [ "$STATUS" != "online" ]; then
    echo "Application not online - current status: $STATUS"
    pm2 logs nextjs_app --lines 100
    exit 1
fi

# Health check with retries and backoff
for i in {1..10}; do
    TIMEOUT=$((i * 2))
    echo "Attempt $i: Testing endpoint (timeout: ${TIMEOUT}s)..."
    
    if curl -s --max-time $TIMEOUT http://localhost:3000/api/health >/dev/null; then
        echo "Application is healthy"
        exit 0
    fi
    
    sleep $TIMEOUT
done

echo "Validation failed - application not responding"
pm2 logs nextjs_app --lines 100
exit 1