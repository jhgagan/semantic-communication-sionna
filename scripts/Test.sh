
#!/bin/bash

# Configuration
VENV_NAME="venvEncoder"
CURRENT_DIR="$(pwd)/../encoder/" # Get absolute path to ensure the new window finds the folder

# ==========================================
# PART 1: Check Python & Create Venv
# ==========================================

# Function to install Python if missing (Simplified for brevity)
check_and_install_python() {
    if ! command -v python3 &> /dev/null; then
        echo "Python3 not found. Attempting to install..."
        OS="$(uname -s)"
        case "$OS" in
            Linux*)  sudo apt-get update && sudo apt-get install -y python3 python3-venv ;;
            Darwin*) brew install python ;;
            *)       echo "Please install Python manually."; exit 1 ;;
        esac
    fi
}

check_and_install_python

# Create Venv if it doesn't exist
if [ ! -d "$VENV_NAME" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv "$VENV_NAME"
fi



# ==========================================
# PART 2: Launch New Window & Activate
# ==========================================

echo "🚀 Launching new terminal window..."
OS_NAME="$(uname -s)"

case "$OS_NAME" in
    # --- LINUX (Gnome Terminal / xterm) ---
    Linux*)
        # We assume Gnome Terminal (Ubuntu/Debian standard). 
        # The command sequence:
        # 1. cd to project
        # 2. source activate
        # 3. exec bash (This keeps the shell open/interactive)
        
        CMD="cd \"$CURRENT_DIR\..\encoder\"; source $VENV_NAME/bin/activate; echo '✅ Venv Activated'; exec bash"
        
        if command -v gnome-terminal &> /dev/null; then
            gnome-terminal -- /bin/bash -c "$CMD"
        elif command -v xterm &> /dev/null; then
            xterm -e /bin/bash -c "$CMD"
        else
            echo "❌ Could not find gnome-terminal or xterm."
        fi
        ;;

    # --- MACOS (Terminal.app) ---
    Darwin*)
        # We use AppleScript to tell Terminal to open a new window and run commands
        osascript <<EOF
            tell application "Terminal"
                do script "cd \"$CURRENT_DIR\..\encoder\"; source $VENV_NAME/bin/activate; clear; echo '✅ Venv Activated'"
                activate
            end tell
EOF
        ;;

    # --- WINDOWS (Git Bash / MinGW) ---
    MINGW*|MSYS*|CYGWIN*)
        # We use 'start mintty' to pop a new Git Bash window
        # Note: Windows uses 'Scripts' folder, not 'bin'
        
        CMD="cd \"$CURRENT_DIR\"; source $VENV_NAME/Scripts/activate; echo '✅ Venv Activated'; exec bash"
        
        # 'exec bash' is crucial here to prevent the window from closing immediately
        start mintty /bin/bash -c "$CMD"
        ;;

    *)
        echo "❌ Unsupported Operating System: $OS_NAME"
        ;;
esac