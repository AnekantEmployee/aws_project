# scripts/start_application.sh
#!/bin/bash
set -e

echo "Starting Next.js application..."

# Navigate to application directory
cd /var/www/nextjs-app

# Start the application with PM2
sudo -u ubuntu pm2 start ecosystem.config.js --env production

# Save PM2 process list
sudo -u ubuntu pm2 save

# Setup PM2 to start on system boot
sudo -u ubuntu pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

echo "Application started successfully!"
