#!/bin/bash

# File: installWine.sh
# Description: Script to install and configure Wine for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install Wine
installWine() {
    echo "Installing Wine..."
    # Add WineHQ repository key
    mkdir -p /etc/apt/keyrings
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

    # Add WineHQ repository
    SYSTEM_VERSION=$(grep "VERSION_CODENAME" /etc/os-release | cut -d'=' -f2)
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/${SYSTEM_VERSION}/winehq-${SYSTEM_VERSION}.sources
    
    # Update package list and install Wine
    apt-get update
    apt-get install -y --install-recommends winehq-stable

    # Set up Wine environment for the root user non-interactively
    echo "Initializing Wine prefix..."
    export WINEPREFIX=/root/.wine
    wineboot -i > /dev/null 2>&1
    
    echo "Wine installation finished."
}

# Run the installation function if --install is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installWine
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs Wine. Use --install or no argument to proceed with installation."
fi
