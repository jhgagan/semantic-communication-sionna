#!/bin/bash
# -----------------------------------------------------
# Script Name:  setup.sh
# Description:  This script will setup the environments
#               and install all the necessary packages.
#               
# Usage:        ./setup.sh [arguments]
#               -h, --help: help 
#               -a, --autoSetup: auto-setup
#               -s, --sionna: install sionna only 
# -----------------------------------------------------

# Exit on error (optional but recommended)
set -e

# Global variables
OS_NAME=""

# Function definitions (if needed)
print_usage() {
    echo "Usage: $0 [options]"
}

sionna_only() {
    auto_detect_os
    if [[ "$OS_NAME" != "win" ]]; then
        echo "Setting up sionna"
        mkdir -p ../sionna
        cp sionna_script.sh ../sionna/
        chmod +x ../sionna/sionna_script.sh
        source ./../sionna/sionna_script.sh

    else
        echo "Unsupported OS for sionna"
        echo "Please use WSL if on windows"
    fi
}

auto_detect_os() {
    echo "Running OS auto detection command"
    OS_NAME=$(uname -s)
    os_based_operations "$OS_NAME"
}

folder_setup() {
    echo "$OS_NAME"
    echo "Setting up encoder side setup"
    mkdir -p ../encoder
    cp encoder_script.sh ../encoder/
    chmod +x ../encoder/encoder_script.sh
    if [[ "$OS_NAME" != "win" ]]; then
        ./../encoder/encoder_script.sh -w
    else
        ./../encoder/encoder_script.sh -l
    fi
    
    
    echo "Setting up decoder side setup"
    mkdir -p ../decoder
    cp decoder_script.sh ../decoder/
    chmod +x ../decoder/decoder_script.sh
    if [[ "$OS_NAME" != "win" ]]; then
        ./../decoder/decoder_script.sh -w
    else
        ./../decoder/decoder_script.sh -l 
    fi

    
    
    if [[ "$OS_NAME" != "win" ]]; then
        echo "Setting up sionna"
        mkdir -p ../sionna
        cp sionna_script.sh ../sionna/
        chmod +x ../sionna/sionna_script.sh
        ./../sionna/sionna_script.sh -l
    fi
}

os_based_operations() {
    case "$1" in 
        CYGWIN*|MINGW*|MSYS*)
            OS_NAME="win"
            ;;
        Darwin)
            OS_NAME="mac"
            ;;
        Linux)
            OS_NAME="lin"
            ;;
        *)
            OS_NAME="NS"
            ;;  
    esac
}

# Parse arguments (optional)
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            print_usage
            exit 0
            ;;
        -a|--autoSetup)
            echo "Complete auto setup requested"
            auto_detect_os
            folder_setup
            exit 0
            ;;
        -s|--sionna)
            echo "setup for sionna"
            sionna_only
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Main logic
echo "Script is running..."

# Example variable
NAME="Gagan"
echo "Hello, $NAME!"

# Example command
DATE_NOW=$(date "+%Y-%m-%d %H:%M:%S")
echo "Current time: $DATE_NOW"

# Exit clean
exit 0
