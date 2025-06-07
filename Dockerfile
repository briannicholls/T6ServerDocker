FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget curl sudo gnupg2 ca-certificates unzip \
    wine64 net-tools ufw nano xz-utils screen \
    && rm -rf /var/lib/apt/lists/*

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                             #
#                            USER CONFIGURATION                               #
#                                                                             #
#         Please modify the values below to configure your server.            #
#                                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Server Name as it will appear in the server list
ENV SERVER_NAME="(\$MLG)B5's Server"

# !! IMPORTANT: SERVER KEY !!
# The server key should be provided when you run the container.
# This keeps it out of the image history. See the README for the command.
ENV SERVER_KEY="YOUR_KEY_HERE"

# "t6mp" or "t6zm"
ENV GAME_MODE="t6mp"
# "/opt/T6Server/Server/Zombie" for zombies
ENV GAME_PATH="/opt/T6Server/Server/Multiplayer"

# Customization Options
# "dedicated_zm.cfg" for zombies
ENV CONFIG_FILE="dedicated.cfg"
ENV MOD=""
ENV ADDITIONAL_PARAMS=""
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                             #
#                          END USER CONFIGURATION                             #
#                                                                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Installation options
# Disable firewall install - port management should be handled by Docker's port mapping features when you run the container
ENV firewall="no"
ENV ssh_port="22"
ENV SERVER_PORT="4976"

# --- Build Stage 1: Installation ---
# This section handles the long-running installation process.
# It will be cached by Docker after the first successful build.

WORKDIR /opt

# Download the T6Server installer files
RUN mkdir -p T6Server && \
    wget -O T6Server.tar.gz https://github.com/Sterbweise/T6Server/releases/download/v3.1.1/T6Server.tar.gz && \
    tar -xzvf T6Server.tar.gz -C T6Server && \
    rm T6Server.tar.gz

WORKDIR /opt/T6Server

# Copy ONLY the files required for the installation script to run.
# By copying these separately, Docker won't re-run the installation
# unless one of *these specific* files or folders changes.
COPY install.sh .
COPY .config/ ./.config/

# Make the install script executable and run it. This is the long step that will now be cached.
RUN chmod +x install.sh && ./install.sh

# --- Build Stage 2: Configuration ---
# This section copies the rest of the files, including the scripts
# we change often. Changes here will NOT trigger a re-install.

# Copy all remaining project files.
COPY . .

# Make all shell scripts in the current directory and subdirectories executable.
# This ensures T6Server.sh and other scripts can be run.
RUN find . -type f -name "*.sh" -exec chmod +x {} +

# Expose server port
EXPOSE 4976/udp

# The CMD is the main process, which keeps the container running so you can exec into it.
CMD ["tail", "-f", "/dev/null"]