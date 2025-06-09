# Alternative Server Configurations

These are pre-configured Dockerfiles for different server types. Simply copy one and use it instead of the main Dockerfile.

## Usage

```bash
# Copy the configuration you want
cp examples/Dockerfile.competitive Dockerfile

# Edit YOUR server settings
nano Dockerfile
# Change SERVER_NAME and SERVER_KEY

# Build and run
docker build -t t6-server .
docker run -d --name my-t6-server -p 4976:4976/udp t6-server
```

## Available Configurations

### 🎯 Casual (Dockerfile.casual)
- **Game Mode:** Team Deathmatch
- **Players:** 18 (full lobbies)
- **Maps:** Popular, fun maps (Nuketown, Hijacked, etc.)
- **Settings:** Standard mode, no friendly fire

### 🏆 Competitive (Dockerfile.competitive)  
- **Game Mode:** Search & Destroy
- **Players:** 12 (6v6 teams)
- **Maps:** Competitive tournament maps
- **Settings:** Pro-style configuration

### ⚔️ Hardcore (Dockerfile.hardcore)
- **Game Mode:** Hardcore Team Deathmatch
- **Players:** 18
- **Maps:** Hardcore-friendly maps
- **Settings:** No HUD, friendly fire ON, realistic damage

## Customization

All configurations use the same environment variables. You can mix and match settings:

```dockerfile
ENV GAME_TYPE="dom"        # Change to Domination
ENV MAX_PLAYERS="12"       # Smaller lobbies
ENV HARDCORE_MODE="true"   # Enable hardcore mode
```

## Available Options

- **Game Types:** `tdm`, `dom`, `snd`, `kc`
- **Max Players:** `1-18`
- **Hardcore Mode:** `true`/`false`
- **Friendly Fire:** `0`/`1` 