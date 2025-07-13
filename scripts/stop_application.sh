#!/bin/bash
set -e

# Log output
LOG_FILE="/var/log/codedeploy-stop.log"
exec > >(tee "$LOG_FILE") 2>&1

echo "Stopping application..."

# Set timeout for the entire script
SCRIPT_TIMEOUT=100  # Leave 20 seconds buffer before CodeDeploy timeout

# Function to run commands with timeout
run_with_timeout() {
    local timeout=$1
    shift
    timeout "$timeout" "$@" || {
        echo "Command timed out after $timeout seconds: $*"
        return 1
    }
}

# Function to forcefully stop processes
force_stop_processes() {
    echo "Force stopping all node processes..."
    
    # Kill all node processes owned by ubuntu user
    pkill -9 -u ubuntu node 2>/dev/null || echo "No node processes found for ubuntu user"
    
    # Kill any remaining processes on port 3000 with timeout
    echo "Checking for processes on port 3000..."
    
    # Use timeout with lsof to prevent hanging
    PIDS=$(run_with_timeout 10 lsof -t -i:3000 2>/dev/null || echo "")
    
    if [ -n "$PIDS" ]; then
        echo "Found processes on port 3000: $PIDS"
        echo "Attempting graceful shutdown..."
        
        # Try graceful shutdown first
        for pid in $PIDS; do
            if kill -TERM "$pid" 2>/dev/null; then
                echo "Sent TERM signal to process $pid"
            fi
        done
        
        # Wait a moment for graceful shutdown
        sleep 3
        
        # Force kill remaining processes
        echo "Force killing remaining processes..."
        for pid in $PIDS; do
            if kill -9 "$pid" 2>/dev/null; then
                echo "Force killed process $pid"
            fi
        done
    else
        echo "No processes found on port 3000"
    fi
}

# Main execution with overall timeout
{
    # Don't fail if PM2 commands fail
    set +e
    
    echo "Attempting to stop PM2 processes..."
    
    # Check if PM2 is installed and working
    if command -v pm2 >/dev/null 2>&1; then
        echo "PM2 found, attempting to stop nextjs_app..."
        
        # Stop PM2 process with timeout
        if run_with_timeout 30 pm2 stop nextjs_app 2>/dev/null; then
            echo "PM2 stop command completed"
        else
            echo "PM2 stop command failed or timed out"
        fi
        
        # Delete PM2 process with timeout
        if run_with_timeout 30 pm2 delete nextjs_app 2>/dev/null; then
            echo "PM2 delete command completed"
        else
            echo "PM2 delete command failed or timed out"
        fi
        
        # Save PM2 process list
        if run_with_timeout 10 pm2 save 2>/dev/null; then
            echo "PM2 save completed"
        else
            echo "PM2 save failed or timed out"
        fi
        
        # Kill PM2 daemon if it's hanging
        if run_with_timeout 10 pm2 kill 2>/dev/null; then
            echo "PM2 daemon killed"
        else
            echo "PM2 kill failed or timed out"
        fi
    else
        echo "PM2 not found, skipping PM2 commands"
    fi
    
    # Force stop any remaining processes
    force_stop_processes
    
    # Final cleanup - remove any PM2 lock files
    echo "Cleaning up PM2 files..."
    rm -rf /home/ubuntu/.pm2/logs/* 2>/dev/null || true
    rm -rf /home/ubuntu/.pm2/pids/* 2>/dev/null || true
    
    set -e
    
    echo "Application stopped successfully"
    
} & # Run in background with timeout

# Wait for background process or timeout
MAIN_PID=$!
sleep $SCRIPT_TIMEOUT && {
    echo "Script timeout reached, killing background process..."
    kill $MAIN_PID 2>/dev/null || true
    force_stop_processes
    exit 0
} &
TIMEOUT_PID=$!

# Wait for main process to complete
wait $MAIN_PID 2>/dev/null
MAIN_EXIT_CODE=$?

# Kill timeout process
kill $TIMEOUT_PID 2>/dev/null || true

# Exit with main process exit code
exit $MAIN_EXIT_CODE