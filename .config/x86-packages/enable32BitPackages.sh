#!/bin/bash

# File: enable32BitPackages.sh
# Description: Script to enable 32-bit architecture support
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--enable" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to enable 32-bit architecture support
enable32BitPackages() {
    echo "Enabling 32-bit packages support (multi-arch)..."
    dpkg --add-architecture i386
    echo "32-bit packages support enabled."
}

# Run the enable function if --enable is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--enable" ]; then
    enable32BitPackages
else
    echo "Usage: $0 [--enable] | [--import]"
    echo "This script enables 32-bit architecture support. Use --enable or no argument to proceed with enabling."
fi
