#!/bin/bash

# T6Server.sh - Enhanced Plutonium Call of Duty: Black Ops II Server Script
# Version: 3.1.1-dockerized
# Author: Sterbweise
# Last Updated: 07/12/2024

# Description:
# This script is designed to run and manage a dedicated server for Call of Duty: Black Ops II
# using the Plutonium client. It supports both Multiplayer and Zombie modes, and includes
# functionality for server updates and automatic restarts.

# This version has been modified to be configurable via environment variables for Docker.

# Usage:
# 1. Configure the variables below according to your server setup
# 2. Run the script with: bash T6Server.sh

# Note: This script requires Wine to be installed on your system to run the Windows executable.

# Configuration variables
# These variables define the basic settings for your server.
# They are read from environment variables, with defaults provided.

# Full path to this script
readonly SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
# Directory containing this script
readonly SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
# Name of your server as it will appear in the server browser
SERVER_NAME="${SERVER_NAME:-My T6 Server}"

# Game path configuration
# This is the path to your game files. Choose the appropriate path based on your game mode.
# For Multiplayer mode, use: "/opt/T6Server/Server/Multiplayer"
# For Zombie mode, use:     "/opt/T6Server/Server/Zombie"
GAME_PATH="${GAME_PATH:-/opt/T6Server/Server/Multiplayer}"

# Your unique server key provided by Plutonium (https://platform.plutonium.pw/serverkeys)
SERVER_KEY="${SERVER_KEY:-YOURKEY}"

# Config file selection
# This is the configuration file for your server. Choose based on your game mode.
# For Multiplayer mode, use: "dedicated.cfg"
# For Zombie mode, use:     "dedicated_zm.cfg"
CONFIG_FILE="${CONFIG_FILE:-dedicated.cfg}"

# The UDP port your server will listen on
SERVER_PORT="${SERVER_PORT:-4976}"

# Game mode selection
# This determines which game mode your server will run.
# For Multiplayer mode, use: "t6mp"
# For Zombie mode, use:     "t6zm"
GAME_MODE="${GAME_MODE:-t6mp}"

# Installation directory of Plutonium
readonly INSTALL_DIR="/opt/T6Server/Plutonium"

# Game mod selection
# This is the game mod that your server will run.
# For Exemple mode, use: "mods/zm_weapons"
MOD="${MOD:-}"

# Note: To switch to Zombie mode, make the following changes:
# 1. Set GAME_PATH to "/opt/T6Server/Server/Zombie"
# 2. Set CONFIG_FILE to "dedicated_zm.cfg"
# 3. Set GAME_MODE to "t6zm"

# Additional startup options
ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS:-}"
# Example:
#     +set sv_network_protocol 1
#     +set sv_maxclients 4
#     +set sv_anticheat 1
#     +set sv_pure 1

# Generate configuration files from environment variables
"$SCRIPT_DIR/generate_configs.sh"

# Function to update server files
# This function uses the Plutonium updater to ensure your server is running the latest version
update_server() {
    ./plutonium-updater -d "$INSTALL_DIR"
}

# Function to start and maintain the server
# This function starts the server and automatically restarts it if it crashes
start_server() {
    local timestamp
    printf -v timestamp '%(%F_%H:%M:%S)T' -1
    
    # Set the terminal title
    echo -e '\033]2;Plutonium - '"$SERVER_NAME"' - Server restart\007'
    
    # Display server information
    echo "Visit plutonium.pw | Join the Discord (plutonium) for NEWS and Updates!"
    echo "Server $SERVER_NAME will load $CONFIG_FILE and listen on port $SERVER_PORT UDP!"
    echo "To shut down the server close this window first!"
    echo "$timestamp $SERVER_NAME server started."

    # Main server loop
    while true; do
        # Start the server using Wine
        nice -n -10 wine ./bin/plutonium-bootstrapper-win32.exe $GAME_MODE "$GAME_PATH" -dedicated \
            +set key "$SERVER_KEY" \
            +set fs_game "$MOD" \
            +set net_port "$SERVER_PORT" \
            +set net_ip 0.0.0.0 \
            +exec "$CONFIG_FILE" \
            $ADDITIONAL_PARAMS \
            +map_rotate \
            2>/dev/null
        
        # If the server stops, log the event and restart
        printf -v timestamp '%(%F_%H:%M:%S)T' -1
        echo "$timestamp WARNING: $SERVER_NAME server closed or dropped... server restarting."
        sleep 1
    done
}

# Main execution
# First update the server, then start it
update_server
start_server
