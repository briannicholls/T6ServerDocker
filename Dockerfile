FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl sudo gnupg2 ca-certificates unzip \
    wine64 net-tools ufw nano xz-utils screen \
    && rm -rf /var/lib/apt/lists/*

# Installation options
ENV firewall="no"
ENV ssh_port="22"
ENV SERVER_PORT="4976"

WORKDIR /opt

# Download the T6Server installer files
RUN mkdir -p T6Server && \
    wget -O T6Server.tar.gz https://github.com/Sterbweise/T6Server/releases/download/v3.1.1/T6Server.tar.gz && \
    tar -xzvf T6Server.tar.gz -C T6Server && \
    rm T6Server.tar.gz

WORKDIR /opt/T6Server

# Copy installation files and run installer
COPY install.sh .
COPY .config/ ./.config/

RUN chmod +x install.sh && ./install.sh

# Run Plutonium updater to pre-download all game files
RUN /opt/T6Server/Plutonium/plutonium-updater -d /opt/T6Server/Plutonium

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                             #
#                            USER CONFIGURATION                               #
#                                                                             #
#         Please modify the values below to configure your server.            #
#                                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Basic Server Settings (REQUIRED)
ENV SERVER_NAME="(\$MLG)B5's Server"
ENV SERVER_KEY="YOUR_KEY"

# Game Mode Configuration  
ENV GAME_MODE="t6mp"
ENV GAME_PATH="/opt/T6Server/Server/Multiplayer"
# Nnote: destination .cfg file is at /opt/T6Server/Server/Multiplayer/main/dedicated.cfg
ENV CONFIG_FILE="dedicated.cfg"

# Simple Gameplay Options (OPTIONAL - change these for different server types)
ENV GAME_TYPE="tdm"
ENV MAX_PLAYERS="2"
ENV MAP_ROTATION="mp_carrier"
# ENV MAP_ROTATION="mp_hijacked mp_nuketown_2020 mp_raid mp_meltdown"
ENV HARDCORE_MODE="true"
ENV FRIENDLY_FIRE="0"

# Advanced Settings (OPTIONAL)
ENV MOD=""
ENV RCON_PASSWORD="required_for_iw4m_admin"
ENV ADDITIONAL_PARAMS=""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                             #
#                          END USER CONFIGURATION                             #
#                                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Copy remaining project files (only invalidated when user config changes)
COPY . .

# Make scripts executable
RUN find . -type f -name "*.sh" -exec chmod +x {} +

# Expose server port
EXPOSE 4976/udp

# Keep the container running in the background
ENTRYPOINT ["tail", "-f", "/dev/null"]