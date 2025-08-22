# Don't Starve Together Server Management - Help

## Overview

This project provides a set of shell scripts to automate the installation, configuration, startup, shutdown, and update of a Don't Starve Together (DST) dedicated server on Linux.

## Main Scripts and Usage

### 1. `setup.sh`
Initializes the environment, installs dependencies, creates the DST user, sets up SteamCMD, and copies scripts.
```bash
./setup.sh
```

### 2. `start.sh`
Starts the DST Master server and, if enabled, the Caves server.
```bash
./start.sh
```

### 3. `stop.sh`
Stops both the Master and Caves servers.
```bash
./stop.sh
```

### 4. `restart.sh`
Restarts the servers, optionally updating the server files.
```bash
./restart.sh [update]
# [update]: 1 to update server files, 0 (default) to just restart
```

### 5. `update.sh`
Restarts the servers and triggers an update.
```bash
./update.sh
```

### 6. `scripts/dst-start.sh`
Starts a specific server shard (Master or Caves).
```bash
./scripts/dst-start.sh <server_type> [cluster_name]
# <server_type>: Master or Caves
# [cluster_name]: Optional, defaults to value in config
```

### 7. `scripts/dst-stop.sh`
Stops a specific server shard.
```bash
./scripts/dst-stop.sh <server_type> [cluster_name] [signal]
# <server_type>: Master or Caves
# [cluster_name]: Optional, defaults to value in config
# [signal]: Optional, default 5 (SIGTRAP)
```


### 8. `scripts/setup-dst-mods.sh`
Generates the mod setup file from `modoverrides.lua`.
```bash
./scripts/setup-dst-mods.sh <DST_CLUSTER_NAME> <DST_SERVER_PATH>
```

If `DST_MOD_ENABLE=1` in your configuration, this script will be run automatically before starting the server (see `start.sh`).


## Configuration

Edit `config/config.properties` to set:
- `STEAMCMD_USERNAME`: Linux user for DST server
- `STEAMCMD_PATH`: SteamCMD install directory
- `DST_SCRIPT_PATH`: Script directory
- `DST_SERVER_PATH`: DST server directory
- `DST_GAME_ID`: DST game ID (default: 343050)
- `DST_CLUSTER_NAME`: Cluster name
- `DST_CAVES_ENABLE`: 1 to enable caves, 0 to disable
- `DST_MOD_ENABLE`: 1 to enable mod setup (run `setup-dst-mods.sh` before server start), 0 to disable

## Directory Structure

- Scripts: `dst_scripts/`
- Config: `dst_scripts/config/`
- Logs: `dst_scripts/log/`
- DST server: `/home/<user>/<DST_SERVER_PATH>/`
- Saves: `/home/<user>/.Klei/DoNotStarveTogether/<DST_CLUSTER_NAME>/`

## Common Tasks

- **Install/Setup:** Run `setup.sh` as root or with sudo.
- **Start Server:** Run `start.sh` as the DST user.
- **Stop Server:** Run `stop.sh` as the DST user.
- **Restart/Update:** Run `restart.sh` or `update.sh` as the DST user.
- **Manage Mods:** Use `setup-dst-mods.sh` after editing `modoverrides.lua`.

## Cron Job for Auto-Update

To enable daily auto-updates, add the cron job:
```bash
crontab -u <DST_USER> /home/<DST_USER>/<DST_SCRIPT_PATH>/config/cron.cmd
```

## Troubleshooting

- Check logs in the `log/` directory for errors.
- Ensure all dependencies are installed (see `setup-sys-*` scripts).
- Make sure the correct user permissions are set for all files and directories.

---
