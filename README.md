# Don't Starve Together Dedicated Server Scripts

This project provides a set of shell scripts to automate the installation, configuration, management, and updating of a Don't Starve Together (DST) dedicated server on Linux.

## Features

- Automated environment setup and dependency installation
- User and permissions management
- Easy server start, stop, restart, and update
- Mod management and auto-generation of mod setup files
- Support for both Master and Caves shards
- Cron job support for automatic updates
- Clear logging and configuration

## Quick Start

1. **Clone or copy this repository to your server.**
2. **Edit `config/config.properties` to match your environment and preferences.**
3. **Run the setup script as root or with sudo:**
	```bash
	./setup.sh
	```
4. **Create a save with mods in your local machine and move it to the server**
    ```
    # For example use scp command move saves and modes:
    scp -r Cluster_1/ ubuntu@host:~/.klei/DoNotStarveTogether/
    ```
5. **Switch to the DST user and start the server:**
	```bash
	su <DST_USER>
	cd ~/<DST_SCRIPT_PATH>
	./start.sh
	```

## Documentation

For detailed usage, script explanations, and troubleshooting, see the [help.md](docs/help.md) file.

## Directory Structure

- `scripts/` — All management and helper scripts
- `config/` — Configuration files
- `log/` — Log files
- `docs/` — Documentation

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

