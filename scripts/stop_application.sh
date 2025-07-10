#!/bin/bash
set -e

# Log output
exec > >(tee /var/log/codedeploy-stop.log) 2>&1

echo "Stopping application..."

# Don't fail if PM2 process doesn't exist
set +e
pm2 stop nextjs_app 2>/dev/null || echo "Application was not running"
pm2 delete nextjs_app 2>/dev/null || echo "No process to delete"
set -e

echo "Application stopped"