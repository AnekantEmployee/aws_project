#!/bin/bash
# scripts/validate_application.sh
# Check if the application is running on the correct port
curl -s http://localhost:3000 | grep "Next.js"  # Or use a more robust check