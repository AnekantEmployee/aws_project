#!/bin/bash
set -e

LOG_FILE="/var/log/codedeploy-start.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Starting application..."
cd /var/www/nextjs_app

# Environment setup
export NODE_ENV=production
export PORT=3000
export HOST=0.0.0.0

# Check if Next.js build exists
if [ ! -d ".next" ]; then
    echo "ERROR: Next.js build not found. Please ensure the build step completed successfully."
    exit 1
fi

# Create PM2 ecosystem file for better process management
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'nextjs_app',
    script: 'npm',
    args: 'start',
    cwd: '/var/www/nextjs_app',
    env: {
      NODE_ENV: 'production',
      PORT: 3000,
      HOST: '0.0.0.0'
    },
    instances: 1,
    exec_mode: 'fork',
    watch: false,
    max_memory_restart: '1G',
    error_file: '/var/log/nextjs_app_error.log',
    out_file: '/var/log/nextjs_app_out.log',
    log_file: '/var/log/nextjs_app_combined.log',
    time: true,
    restart_delay: 4000,
    max_restarts: 10,
    min_uptime: '10s'
  }]
}
EOF

# Stop any existing process
pm2 stop nextjs_app 2>/dev/null || echo "No existing process to stop"
pm2 delete nextjs_app 2>/dev/null || echo "No existing process to delete"

# Wait a moment for cleanup
sleep 2

# Start application using ecosystem file
echo "Starting Next.js server with PM2..."
pm2 start ecosystem.config.js

# Save PM2 process list
pm2 save

# Setup PM2 startup script (only if not already configured)
if ! pm2 startup | grep -q "already configured"; then
    pm2 startup systemd -u ubuntu --hp /home/ubuntu | bash
fi

# Wait for application to start
echo "Waiting for application to initialize..."
sleep 5

echo "Application started successfully"

# Show PM2 status
pm2 status
pm2 logs nextjs_app --lines 10 || true