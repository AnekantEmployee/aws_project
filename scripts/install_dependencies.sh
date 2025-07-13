# scripts/install_dependencies.sh
#!/bin/bash
set -e

echo "Installing dependencies for Next.js application..."

# Navigate to application directory
cd /var/www/nextjs-app

# Install Node.js and npm if not already installed
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt-get install -y nodejs
fi

# Install PM2 globally if not already installed
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
fi

# Install application dependencies
npm ci --production

# Build the Next.js application
npm run build

# Set proper ownership
chown -R ubuntu:ubuntu /var/www/nextjs-app

echo "Dependencies installed successfully!"