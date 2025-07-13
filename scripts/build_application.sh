#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-build.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Starting application build..."

cd /var/www/nextjs_app

# Set environment for build
export NODE_ENV=production
export NODE_OPTIONS="--max-old-space-size=4096"

# Check if build script exists
if ! npm run build --dry-run &>/dev/null; then
    echo "ERROR: build script not found in package.json"
    exit 1
fi

# Build the application
echo "Building Next.js application..."
npm run build

# Verify build output
if [ ! -d ".next" ]; then
    echo "ERROR: Build failed - .next directory not found"
    exit 1
fi

echo "Build completed successfully"
echo "Build output:"
ls -la .next/

# Remove dev dependencies after build to save space
echo "Removing dev dependencies..."
npm ci --only=production --no-optional

echo "Production dependencies only:"
npm list --depth=0 || true