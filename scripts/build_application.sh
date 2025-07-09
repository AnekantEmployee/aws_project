#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-build.log) 2>&1

echo "Starting application build..."

cd /var/www/nextjs_app

# Build the application
echo "Building Next.js application..."
npm run build

echo "Build completed successfully"