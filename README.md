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

This project provides a Dockerized solution for running a Plutonium Call of Duty: Black Ops II dedicated server. It is based on the excellent [T6Server installer by Sterbweise](https://github.com/Sterbweise/T6Server), adapted to run in a self-contained Docker container. This simplifies setup, configuration, and deployment, allowing you to get a server running with just a few commands.

The `install.sh` script from the original repository has been modified to run non-interactively within the Docker build. If you wish to run the installer manually in an interactive mode (for example, on a non-Docker system), you can do so by setting the `INTERACTIVE` environment variable:
```bash
sudo INTERACTIVE=yes ./install.sh
```

## Table of Contents

- [T6 Server - Dockerized Plutonium Black Ops II Server](#t6-server---dockerized-plutonium-black-ops-ii-server)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [1. Clone the Repository](#1-clone-the-repository)
    - [2. Configure the Server in Dockerfile](#2-configure-the-server-in-dockerfile)
    - [3. Build the Docker Image](#3-build-the-docker-image)
    - [4. Run the Container](#4-run-the-container)
    - [5. Access and Manage the Server](#5-access-and-manage-the-server)
    - [6. Start the Server](#6-start-the-server)
  - [Server Management](#server-management)
    - [Viewing Logs and Console](#viewing-logs-and-console)
    - [Stopping the Server](#stopping-the-server)
    - [Customizing Your Server](#customizing-your-server)
  - [Advanced Configuration](#advanced-configuration)
    - [Custom Mods and Maps](#custom-mods-and-maps)
    - [Directory Structure](#directory-structure)
  - [Troubleshooting](#troubleshooting)
  - [Documentation](#documentation)
  - [Contributing](#contributing)
  - [License](#license)
  - [Acknowledgements](#acknowledgements)
  - [Support](#support)

## Features
- **Easy Deployment:** Run a full T6 server with a single `docker run` command.
- **Self-Contained:** All dependencies (like Wine) are managed within the Docker image.
- **Configurable:** Easily configure your server using environment variables in the `Dockerfile`.
- **Reproducible:** Get the exact same server environment every time you build the image.
- **Based on T6Server:** Includes the robust features from the original T6Server installer.
- **MOD Support:** Easily add custom maps and mods using Docker volumes.

## Prerequisites
- **Docker:** You must have Docker installed on your system. Visit the [official Docker website](https://www.docker.com/get-started) for installation instructions.
- **Git:** For cloning the repository.
- **Plutonium Server Key:** You need a server key from the [Plutonium website](https://platform.plutonium.pw/serverkeys).

## Getting Started

Follow these steps to get your server up and running.

### 1. Clone the Repository
```bash
# Make sure to use the URL for your forked repository
git clone https://github.com/bfive/T6ServerDocker.git
cd T6ServerDocker
```

### 2. Configure the Server in Dockerfile
Open the `Dockerfile` in a text editor. Find the `USER CONFIGURATION` section and set your `SERVER_NAME` and, most importantly, your `SERVER_KEY`.

You **must** replace `"YOUR_KEY_HERE"` with your actual key from the Plutonium website.

### 3. Build the Docker Image
This command builds your Docker image. This may take some time on the first run, but subsequent builds will be much faster thanks to caching.

```bash
docker build -t t6-server .
```

### 4. Run the Container
This command starts your container in the background. All configuration is now read directly from the `Dockerfile`.

```bash
docker run -d \
  --name my-t6-server \
  -p 4976:4976/udp \
  t6-server
```

### 5. Access and Manage the Server
Now you can get a `bash` shell inside the running container to manage your server.

```bash
docker exec -it my-t6-server bash
```
All environment variables are now set directly from the `Dockerfile`.

### 6. Start the Server
For clarity and good practice, it's best to first navigate to the script's directory before running it.

```bash
# Navigate to the directory containing the server script
cd /opt/T6Server/Plutonium

# Launch the server
./T6Server.sh
```
Your server is now running!

## Server Management

### Viewing Logs and Console
If you follow the steps above, the server console will be attached to your `docker exec` session. If you detach from the session, you can re-attach to view the console:
```bash
docker attach my-t6-server
```

### Stopping the Server
To stop the server container completely:
```bash
docker stop my-t6-server
```

## Customizing Your Server (Work in progress)
The power of this Docker setup comes from using **volumes** to mount your local files and folders into the container. This is an alternative to editing files inside the container with `docker exec`. It allows you to manage your server configuration, mods, and scripts on your host machine.

Here are some common examples:

### Using a Custom `dedicated.cfg`
To use a config file from your host machine:
1. Create a file named `dedicated.cfg` on your host.
2. When you run your container, mount your file to the correct location:
```bash
# The -v flag mounts your local file into the container
docker run -d \
  -p 4976:4976/udp \
  -v ./dedicated.cfg:/opt/T6Server/Server/Multiplayer/main/dedicated.cfg \ # TODO: make sure this path is correct
  --name my-t6-server \
  t6-server
```
Now, any changes you make to your local `dedicated.cfg` will be reflected inside the container.

### Adding Custom Mods and Scripts (Work in progress)
You can mount entire folders, which is perfect for mods and scripts.

1. Create a folder on your host machine for your mods (e.g., `my_server_files/mods`).
2. In your `Dockerfile`, set the `MOD` environment variable to point to your mod folder. For example:
   ```dockerfile
   # In Dockerfile
   ENV MOD="mods/my_awesome_mod"
   ```
3. Build (or rebuild) your image with the updated `MOD` variable.
4. Run your container, mounting your local mods folder into the container:
```bash
docker run -d \
  -p 4976:4976/udp \
  -v ./my_server_files/mods:/opt/T6Server/Plutonium/storage/t6/mods \
  --name my-t6-server \
  t6-server
```
When you run `./T6Server.sh`, it will now automatically load the mod you specified in your `Dockerfile`.

## Advanced Configuration

### Custom Mods and Maps (Work in progress)
To use custom mods or maps, you need to mount local directories from your host machine into the container using Docker volumes. This makes your local files available inside the container.

For example, if you have a `mods` folder on your host at `/home/user/t6_mods`, you would run the container like this:

```bash
docker run -d \
  -p 4976:4976/udp \
  -v /home/user/t6_mods:/opt/T6Server/Plutonium/storage/t6/mods \
  --name my-t6-server \
  t6-server
```
You can mount multiple volumes for different types of content (maps, scripts, etc.).

### Directory Structure
Here are the key directories inside the container where you can mount your custom content:

| Directory | Path | Description |
|-----------|------|-------------|
| **Mods** | `/opt/T6Server/Plutonium/storage/t6/mods/` | Custom game modifications |
| **Config - Multiplayer** | `/opt/T6Server/Server/Multiplayer/main/configs/` | Multiplayer configuration files |
| **Config - Zombie** | `/opt/T6Server/Server/Zombie/main/configs/` | Zombie mode configuration files |
| **Logs** | `/opt/T6Server/Plutonium/storage/t6/logs/` | Server log files |
| **Scripts** | `/opt/T6Server/Plutonium/storage/t6/scripts/` | Custom game scripts |
| **Maps - Multiplayer** | `/opt/T6Server/Server/Multiplayer/usermaps/` | Custom multiplayer maps |
| **Maps - Zombie** | `/opt/T6Server/Server/Zombie/usermaps/` | Custom zombie maps |

## Troubleshooting

- **Server not appearing in list:**
  - Ensure you have correctly mapped the port with `-p <host_port>:<container_port>/udp`.
  - Check your firewall/router settings to ensure the host port is open to the internet.
  - Double-check that your `SERVER_KEY` is correct in the `Dockerfile`.
- **Docker command errors:**
  - Make sure the Docker daemon is running.
  - Check for typos in your `docker` commands.
- **Container won't start:**
  - Use `docker logs my-t6-server` (without `-f`) to check for any startup errors.

## Documentation

For more detailed information on Plutonium server configuration and options, please refer to the original project's [Wiki](https://github.com/Sterbweise/T6Server/wiki).

## Contributing

Contributions are welcome, please feel free to fork the repository, make changes, and submit a pull request.

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
