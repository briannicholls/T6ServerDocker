# T6 Server - Dockerized Plutonium Black Ops II Server

![Version](https://img.shields.io/badge/Version-3.1.1--dockerized-blue)
![Docker](https://img.shields.io/badge/Docker-Required-blue?logo=docker)
![Plutonium T6](https://img.shields.io/badge/Plutonium-T6-blue)
![License](https://img.shields.io/badge/License-GPL--3.0-yellow)
![GitHub repo size](https://img.shields.io/github/repo-size/Sterbweise/T6Server)
![GitHub stars](https://img.shields.io/github/stars/Sterbweise/T6Server)
![GitHub forks](https://img.shields.io/github/forks/Sterbweise/T6Server)

<div style="display: flex; align-items: center;">
    <img src="https://github.com/user-attachments/assets/3ee17ff5-25fa-494e-b874-610507794756" alt="image" width="400"/>
    <img src="https://imgur.com/bBrx8Hf.png" alt="Plutonium showLogo" width="400" style="margin-left: 10px;"/>
</div>

This project provides a Dockerized solution for running a Plutonium Call of Duty: Black Ops II dedicated server. It is based on the excellent [T6Server installer by Sterbweise](https://github.com/Sterbweise/T6Server), adapted to run in a self-contained Docker container with **simple configuration through environment variables**.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Applying Configuration Changes](#applying-configuration-changes)
- [Alternative Configurations](#alternative-configurations)
- [Configuration Options](#configuration-options)
- [Server Management](#server-management)
- [Advanced Configuration](#advanced-configuration)
- [Troubleshooting](#troubleshooting)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Support](#support)

## Features
- **Easy Deployment:** Run a full T6 server with a single `docker run` command.
- **Simple Configuration:** Edit one Dockerfile to configure everything - no complex CFG files.
- **Self-Contained:** All dependencies (like Wine) are managed within the Docker image.
- **Auto-Generated Configs:** Plutonium configs generated automatically from your settings.
- **Pre-configured Examples:** Ready-to-use Dockerfiles for different server types.
- **Based on T6Server:** Includes the robust features from the original T6Server installer.
- **MOD Support:** Easily add custom maps and mods using Docker volumes.

## Prerequisites
- **Docker:** You must have Docker installed on your system. Visit the [official Docker website](https://www.docker.com/get-started) for installation instructions.
- **Git:** For cloning the repository.
- **Plutonium Server Key:** You need a server key from the [Plutonium website](https://platform.plutonium.pw/serverkeys).

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/bfive/T6ServerDocker.git
cd T6ServerDocker
```

### 2. Configure Your Server
Open the `Dockerfile` and edit the `USER CONFIGURATION` section:

```dockerfile
# Basic Server Settings (REQUIRED)
ENV SERVER_NAME="My Awesome Server"
ENV SERVER_KEY="your_plutonium_key_here"

# Simple Gameplay Options (OPTIONAL)
ENV GAME_TYPE="tdm"
ENV MAX_PLAYERS="18"
ENV HARDCORE_MODE="false"
ENV FRIENDLY_FIRE="0"
```

### 3. Build the Docker Image
```bash
docker build -t t6-server .
```

### 4. Run the Container
```bash
docker run -d \
  --name my-t6-server \
  -p 4976:4976/udp \
  t6-server
```

### 5. Start Your Server
```bash
docker exec -it my-t6-server bash
cd /opt/T6Server/Plutonium
./T6Server.sh
```

Your server is now running!

## Applying Configuration Changes

If you change any of the `ENV` variables in your `Dockerfile`, you need to rebuild the image and restart the container for the changes to take effect.

Here is the full workflow:

1.  **Stop the running container:**
    ```bash
    docker stop my-t6-server
    ```

2.  **Remove the old container:**
    ```bash
    docker rm my-t6-server
    ```

3.  **Rebuild your Docker image with the new configuration:**
    ```bash
    docker build -t t6-server .
    ```

4.  **Start the server process inside the new container:**
    ```bash
    docker exec -it my-t6-server bash
    cd /opt/T6Server/Plutonium
    ./T6Server.sh
    ```

## Alternative Configurations

Want a specific server type? Copy a pre-configured Dockerfile:

### 🎯 Casual Server (Team Deathmatch)
```bash
cp examples/Dockerfile.casual Dockerfile
nano Dockerfile  # Edit SERVER_NAME and SERVER_KEY
docker build -t t6-server .
```

### 🏆 Competitive Server (Search & Destroy)
```bash
cp examples/Dockerfile.competitive Dockerfile
nano Dockerfile  # Edit SERVER_NAME and SERVER_KEY
docker build -t t6-server .
```

### ⚔️ Hardcore Server (Hardcore TDM)
```bash
cp examples/Dockerfile.hardcore Dockerfile
nano Dockerfile  # Edit SERVER_NAME and SERVER_KEY
docker build -t t6-server .
```

Then build and run as normal!

## Configuration Options

All configuration is done through environment variables in the Dockerfile:

| Setting | Description | Default | Options |
|---------|-------------|---------|---------|
| `SERVER_NAME` | Your server name | `"(\$MLG)B5's Server"` | Any string |
| `SERVER_KEY` | **Plutonium key** | `"YOUR_KEY_HERE"` | Get from [plutonium.pw](https://platform.plutonium.pw/serverkeys) |
| `GAME_TYPE` | Game mode | `"tdm"` | `"tdm"`, `"dom"`, `"snd"`, `"kc"` |
| `MAX_PLAYERS` | Player limit | `"2"` | `"1"` to `"18"` |
| `MAP_ROTATION` | Map list | `"mp_carrier"` | Space-separated map codes |
| `HARDCORE_MODE` | Hardcore mode | `"true"` | `"true"`/`"false"` |
| `FRIENDLY_FIRE` | Team damage | `"0"` | `"0"`/`"1"` |
| `MOD` | Custom mod folder | `""` | `"mods/modname"` |
| `RCON_PASSWORD` | Remote control password | `""` | Any string |

### Game Types
- **`tdm`** - Team Deathmatch (default)
- **`dom`** - Domination  
- **`snd`** - Search & Destroy
- **`kc`** - Kill Confirmed

### Popular Maps
- `mp_nuketown_2020` - Nuketown 2025
- `mp_hijacked` - Hijacked  
- `mp_raid` - Raid
- `mp_drone` - Drone
- `mp_meltdown` - Meltdown
- `mp_express` - Express
- `mp_carrier` - Carrier

## Server Management

### Viewing Logs and Console
```bash
# View container logs
docker logs my-t6-server

# Access server console
docker exec -it my-t6-server bash
```

### Stopping the Server
```bash
docker stop my-t6-server
```

### Restarting with New Configuration
```bash
# Stop and remove container
docker stop my-t6-server && docker rm my-t6-server

# Rebuild with new configuration
docker build -t t6-server .

# Start new container
docker run -d --name my-t6-server -p 4976:4976/udp t6-server
```

## Advanced Configuration

### Custom Mods and Maps
To use custom mods or maps, mount local directories into the container:

```bash
docker run -d \
  --name my-t6-server \
  -p 4976:4967/udp \
  -v ./my_mods:/opt/T6Server/Plutonium/storage/t6/mods \
  -v ./my_maps:/opt/T6Server/Server/Multiplayer/usermaps \
  t6-server
```

### Key Directory Paths

| Content Type | Container Path | Description |
|--------------|----------------|-------------|
| **Mods** | `/opt/T6Server/Plutonium/storage/t6/mods/` | Custom game modifications |
| **MP Maps** | `/opt/T6Server/Server/Multiplayer/usermaps/` | Custom multiplayer maps |
| **ZM Maps** | `/opt/T6Server/Server/Zombie/usermaps/` | Custom zombie maps |
| **Configs** | `/opt/T6Server/Server/Multiplayer/main/` | Configuration files |
| **Scripts** | `/opt/T6Server/Plutonium/storage/t6/scripts/` | Custom game scripts |

### Environment Variable Override
You can also override settings at runtime:

```bash
docker run -d \
  --name my-t6-server \
  -p 4976:4976/udp \
  -e SERVER_NAME="Runtime Server Name" \
  -e GAME_TYPE="dom" \
  -e MAX_PLAYERS="12" \
  t6-server
```

## Troubleshooting

- **Server not appearing in list:**
  - Ensure you have correctly set your `SERVER_KEY` in the Dockerfile
  - Check port mapping: `-p 4976:4976/udp`
  - Verify firewall/router allows UDP traffic on port 4976
  - Check Docker logs: `docker logs my-t6-server`

- **Container won't start:**
  - Check for build errors: `docker build -t t6-server .`
  - Verify Docker daemon is running
  - Check for typos in your Dockerfile configuration

- **Configuration not applied:**
  - Rebuild the image after changing the Dockerfile: `docker build -t t6-server .`
  - Remove old container before starting new one: `docker rm my-t6-server`

## Documentation

For more detailed information on Plutonium server configuration and options, please refer to the original project's [Wiki](https://github.com/Sterbweise/T6Server/wiki).

## Contributing

Contributions are welcome! Please feel free to fork the repository, make changes, and submit a pull request.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- **Sterbweise**: For creating the original, comprehensive [T6Server](https://github.com/Sterbweise/T6Server) project.
- **Plutonium**: For their exceptional work on the T6 client and server.
- **plutonium-updater**: For the tool that streamlines server updates.

## Support

For support, please open an issue on this repository.

---

Installer Developed with ❤️ by [Sterbweise](https://github.com/Sterbweise)

Dockerized with ❤️ by [bfive](https://github.com/bfive)

