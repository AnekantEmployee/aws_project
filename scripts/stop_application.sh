#!/bin/bash
# Log output
exec > >(tee /var/log/codedeploy-stop.log) 2>&1

echo "Stopping application..."

# Stop PM2 process
pm2 stop nextjs_app || echo "Application was not running"
pm2 delete nextjs_app || echo "No process to delete"

echo "Application stopped"