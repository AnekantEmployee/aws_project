# Additional script: scripts/create_log_directory.sh
#!/bin/bash
set -e

echo "Creating log directory..."

# Create log directory
mkdir -p /var/log/nextjs-app
chown ubuntu:ubuntu /var/log/nextjs-app

echo "Log directory created!"
