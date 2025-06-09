#!/bin/bash

# generate_configs.sh - Generates server configuration files from environment variables
# This makes server configuration much easier for users

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="/opt/T6Server/Server/Multiplayer/main"
GAMESETTINGS_DIR="$CONFIG_DIR/gamesettings"

# Set defaults for optional variables
SERVER_MESSAGE="${SERVER_MESSAGE:-Welcome to the server!}"
KILLCAM="${KILLCAM:-1}"
VOTE_KICK="${VOTE_KICK:-1}"
TEAM_BALANCE="${TEAM_BALANCE:-1}"

# Create directories if they don't exist
mkdir -p "$GAMESETTINGS_DIR"

# Function to generate dedicated.cfg
generate_dedicated_cfg() {
    cat > "$CONFIG_DIR/dedicated.cfg" << EOF
// Generated T6 Server Configuration
// Auto-generated from Docker environment variables

// Server Identity
set sv_hostname "$SERVER_NAME"
set sv_motd "$SERVER_MESSAGE"
set sv_maxclients $MAX_PLAYERS

// Network Settings
set dedicated 2
set net_port $SERVER_PORT

// Game Mode Settings
$(generate_map_rotation)

// Basic Gameplay
set scr_hardcore $([ "$HARDCORE_MODE" = "true" ] && echo "1" || echo "0")
set scr_friendlyfire $FRIENDLY_FIRE
set scr_killcam $KILLCAM
set g_allowvote $VOTE_KICK
set scr_teambalance $TEAM_BALANCE

// Spectator Settings
set g_spectatorInactivity 0
set scr_spectatorInactivity 0

// Additional custom parameters
$ADDITIONAL_PARAMS
EOF
}

# Function to generate map rotation based on settings
generate_map_rotation() {
    if [ "$HARDCORE_MODE" = "true" ]; then
        # Hardcore mode rotation
        echo "set sv_maprotation \"exec hc${GAME_TYPE}.cfg $(echo $MAP_ROTATION | sed 's/\([^ ]*\)/map \1/g')\""
    else
        # Standard mode rotation
        echo "set sv_maprotation \"exec ${GAME_TYPE}.cfg $(echo $MAP_ROTATION | sed 's/\([^ ]*\)/map \1/g')\""
    fi
}

# Function to generate game mode specific configs
generate_gamemode_configs() {
    # Generate standard game mode configs
    generate_tdm_config
    generate_dom_config
    generate_snd_config
    generate_kc_config
    
    # Generate hardcore variants if needed
    if [ "$HARDCORE_MODE" = "true" ]; then
        generate_hardcore_configs
    fi
}

generate_tdm_config() {
    cat > "$GAMESETTINGS_DIR/tdm.cfg" << EOF
// Team Deathmatch Configuration
set scr_war_scorelimit 75
set scr_war_timelimit 10
set scr_war_playerrespawndelay 0
set scr_war_waverespawndelay 0
set scr_war_numlives 0
set scr_war_promode 0
EOF
}

generate_dom_config() {
    cat > "$GAMESETTINGS_DIR/dom.cfg" << EOF
// Domination Configuration  
set scr_dom_scorelimit 200
set scr_dom_timelimit 0
set scr_dom_playerrespawndelay 0
set scr_dom_waverespawndelay 0
set scr_dom_numlives 0
set scr_dom_promode 0
EOF
}

generate_snd_config() {
    cat > "$GAMESETTINGS_DIR/snd.cfg" << EOF
// Search and Destroy Configuration
set scr_sd_scorelimit 4
set scr_sd_timelimit 2.5
set scr_sd_playerrespawndelay 0
set scr_sd_waverespawndelay 0
set scr_sd_numlives 1
set scr_sd_promode 0
set scr_sd_bombtimer 45
set scr_sd_defusetime 5
set scr_sd_multibomb 0
set scr_sd_planttime 5
EOF
}

generate_kc_config() {
    cat > "$GAMESETTINGS_DIR/kc.cfg" << EOF
// Kill Confirmed Configuration
set scr_koth_scorelimit 65
set scr_koth_timelimit 10
set scr_koth_playerrespawndelay 0
set scr_koth_waverespawndelay 0
set scr_koth_numlives 0
set scr_koth_promode 0
EOF
}

generate_hardcore_configs() {
    # Generate hardcore variants
    for mode in tdm dom snd kc; do
        cp "$GAMESETTINGS_DIR/${mode}.cfg" "$GAMESETTINGS_DIR/hc${mode}.cfg"
        cat >> "$GAMESETTINGS_DIR/hc${mode}.cfg" << EOF

// Hardcore Mode Settings
set scr_hardcore 1
set scr_player_healthregentime 0
set scr_team_teamkillspawndelay 750
EOF
    done
}

# Main execution
echo "Generating server configuration files..."
generate_dedicated_cfg
generate_gamemode_configs
echo "Configuration files generated successfully!"
echo "Files created in: $CONFIG_DIR" 