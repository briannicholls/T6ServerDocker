#!/bin/bash

# File: installGameBinaries.sh
# Description: Script to install game binaries for the Plutonium Call of Duty: Black Ops II Server
# Version: 3.1.1
# Author: Sterbweise
# Last Updated: 07/12/2024

# Import global configurations
if [ "$1" = "--install" ]; then
    source /opt/T6Server/.config/config.sh
fi

# Function to install game binaries
installGameBinaries () {
    echo "Starting installation of game binaries..."

    # Create directory structure for Plutonium
    mkdir -p "$WORKDIR/Plutonium/storage/t6/"{players,gamesettings,playlists,stats,scripts,mods}

    # Create directory structure for Multiplayer & Zombie
    mkdir -p "$WORKDIR/Server/Multiplayer/usermaps" "$WORKDIR/Server/Multiplayer/main/configs"
    mkdir -p "$WORKDIR/Server/Zombie/usermaps" "$WORKDIR/Server/Zombie/main/configs"

    # Clone T6ServerConfigs repository
    rm -rf /tmp/T6ServerConfigs
    checkAndInstallCommand "git" "git"
    echo "Cloning server configurations..."
    git clone --quiet https://github.com/xerxes-at/T6ServerConfigs.git /tmp/T6ServerConfigs

    # Install rsync if not present
    checkAndInstallCommand "rsync" "rsync"

    # Copy configuration files and game settings
    echo "Copying configuration files..."
    rsync -aq "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/gamesettings_defaults (REFERENCE ONLY)/" "$WORKDIR/Plutonium/storage/t6/gamesettings/default/"
    rsync -aq "/tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/dedicated.cfg" "$WORKDIR/Server/Multiplayer/main/"
    rsync -aq --remove-source-files /tmp/T6ServerConfigs/localappdata/Plutonium/storage/t6/gamesettings/* "$WORKDIR/Plutonium/storage/t6/gamesettings/"
    
    # Clean up T6ServerConfigs
    rm -rf /tmp/T6ServerConfigs

    # Download required files from torrent
    echo "Downloading game files via aria2c... This may take a while."
    checkAndInstallCommand "aria2c" "aria2"
    rm -rf /tmp/pluto_t6_full_game* # Clean up previous attempts
    aria2c --quiet=true --dir=/tmp --seed-time=0 --console-log-level=error --summary-interval=0 --select-file=$(aria2c -S "$WORKDIR/Resources/sources/pluto_t6_full_game.torrent" | grep -E "zone/|binkw32.dll" | cut -d'|' -f1 | tr '\n' ',') "$WORKDIR/Resources/sources/pluto_t6_full_game.torrent"

    # Move downloaded files to Resources
    echo "Moving downloaded game files..."
    mkdir -p "$WORKDIR/Resources/binaries"
    rsync -aq "/tmp/pluto_t6_full_game/zone/" "$WORKDIR/Resources/binaries/zone/"
    rsync -aq "/tmp/pluto_t6_full_game/binkw32.dll" "$WORKDIR/Resources/binaries/binkw32.dll"

    # Clean up downloaded files
    rm -rf /tmp/pluto_t6_full_game

    # Create symbolic links
    echo "Creating symbolic links..."
    for dir in Zombie Multiplayer; do
        ln -sfn "$WORKDIR/Resources/binaries/zone" "$WORKDIR/Server/$dir/zone"
        ln -sfn "$WORKDIR/Resources/binaries/binkw32.dll" "$WORKDIR/Server/$dir/binkw32.dll"
    done

    # Setup Plutonium updater
    echo "Setting up Plutonium updater..."
    if [ ! -f "$WORKDIR/Plutonium/plutonium-updater" ]; then
        cd "$WORKDIR/Plutonium/" || exit
        checkAndInstallCommand "wget" "wget"
        wget -q -O plutonium-updater.tar.gz https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
        checkAndInstallCommand "tar" "tar"
        tar xf plutonium-updater.tar.gz plutonium-updater
        rm plutonium-updater.tar.gz
        chmod +x plutonium-updater
    fi

    # Make T6Server.sh executable
    chmod +x "$WORKDIR/Plutonium/T6Server.sh"
    
    echo "Game binaries installation finished."
    
    # Verify installation
    if [ ! -f "$WORKDIR/Plutonium/plutonium-updater" ]; then
        printf "${COLORS[RED]}Error:${COLORS[RESET]} Game binaries installation failed.\n"
        printf "You can try running the installation script separately by executing:\n"
        printf "cd .config/binaries && ./installGameBinaries.sh\n"
    fi
}

# Run the installation function if --install is provided
if [ "$1" = "--import" ]; then
    :
elif [ "$1" = "--install" ]; then
    installGameBinaries
else
    echo "Usage: $0 [--install] | [--import]"
    echo "This script installs game binaries. Use --install or no argument to proceed with installation."
fi
