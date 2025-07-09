#!/bin/bash
# scripts/stop_application.sh
pm2 stop nextjs_app || true # Stop the application using pm2 or similar