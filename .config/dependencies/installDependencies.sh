#!/bin/bash

# File: installDependencies.sh
# Description: Script to install dependencies for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install dependencies
installDependencies() {
    echo "Installing dependencies..."
    apt-get install -y \
        dialog \
        jq \
        iproute2 \
        net-tools \
        curl \
        wget \
        sudo \
        gnupg2 \
        ca-certificates \
        unzip \
        nano \
        xz-utils \
        screen \
        git \
        rsync \
        aria2 \
        procps
    echo "Dependency installation finished."
}

# Run the installation function if --install is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installDependencies
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs dependencies. Use --install or no argument to proceed with installation."
fi
