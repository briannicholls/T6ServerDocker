#!/bin/bash

# File: installDotnet.sh
# Description: Script to install .NET for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install .NET
installDotnet() {
    echo "Installing .NET..."
    # Check if dotnet is already installed
    if command -v dotnet &> /dev/null; then
        echo ".NET is already installed."
        return
    fi
    
    checkAndInstallCommand "wget" "wget"

    # Download and install Microsoft keys and repository
    wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    # Update packages and install .NET runtime
    apt-get update
    apt-get install -y apt-transport-https && apt-get install -y aspnetcore-runtime-8.0
    
    # Clean apt cache
    apt-get clean
    apt-get autoremove -y

    # Verify installation
    if ! command -v dotnet &> /dev/null
    then
        printf "${COLORS[RED]}Error:${COLORS[RESET]} Dotnet installation failed.\n"
        exit 1
    fi
    echo ".NET installation finished."
}

# Run the installation function if --install or --import is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installDotnet
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs .NET or imports the configuration. Use --install or --import to proceed with installation or import."
fi
