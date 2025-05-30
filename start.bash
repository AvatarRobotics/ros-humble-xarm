#!/bin/bash

# Function to handle SIGINT
cleanup() {
    echo "Received SIGINT. Exiting..."
    sudo xrdp-sesman -k -n
    sudo xrdp -k -n
    exit 0
}

# Make sure we're clean if was shutdown unexpectedly
sudo rm -f /var/run/xrdp/xrdp.pid
sudo rm -f /var/run/xrdp/xrdp-sesman.pid
# Start xrdp and xrdp-sesman in daemon mode
sudo xrdp
sudo xrdp-sesman

# Set up the trap for SIGINT
trap cleanup SIGINT

echo "Started container. Press Ctrl+C to exit."
while true; do
    sleep 1
done
