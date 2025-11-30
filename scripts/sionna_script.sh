#!/bin/bash
# -----------------------------------------------------
# Script Name:  setup.sh
# Description:  This script will setup the environments
#               and install all the necessary packages.
#               
# Usage:        ./setup.sh [arguments]
# -----------------------------------------------------

# Exit on error (optional but recommended)
set -e

# Function definitions (if needed)
print_usage() {
    echo "Usage: $0 [options]"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -w|--win)
            break
        ;;
        -l|--lin)
            echo "success"
            break
        ;;
        -m|--mac)
            break
        ;;
        *)
            echo "Unsupported OS: $1"
            exit 1
            ;;
    esac
done

# Main logic
echo "Script is running..."

# Example variable
NAME="from sionna"
echo "Hello, $NAME!"

# Example command
DATE_NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "Current time: $DATE_NOW"
