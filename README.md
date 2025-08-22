# 饥荒联机版专用服务器脚本

[English | 中文](README.md | README-zh.md)

# Don't Starve Together Dedicated Server Scripts

This project provides a set of shell scripts to automate the installation, configuration, management, and updating of a Don't Starve Together (DST) dedicated server on Linux.

Forked from [cuukenn/dontstarveserver](https://github.com/cuukenn/dontstarveserver), this project adds mod management and automatic generation of mod setup files. It also improves code readability and introduces multi-language prompts for a better user experience.

## Features

- Automated environment setup and dependency installation
- User and permissions management
- Easy server start, stop, restart, and update
- Mod management and auto-generation of mod setup files (newly added)
- Support for both Master and Caves shards
- Cron job support for automatic updates
- Clear logging and configuration
- Multi-language prompt support (English/Chinese)

## Quick Start

1. **Clone or copy this repository to your server.**
2. **Edit `config/config.properties` to match your environment and preferences.**
3. **Run the setup script as root or with sudo:**
	```bash
	./setup.sh
	```
4. **Create a save with mods in your local machine and move it to the server**
	 ```
	 # For example use scp command to move saves and modes:
	 scp -r <CLUSTER_PATH>/ <DST_USER>@<HOST>:~/.klei/DoNotStarveTogether/
	 ```
5. **Switch to the DST user and start the server:**
	```bash
	su <DST_USER>
	cd ~/<DST_SCRIPT_PATH>
	./start.sh
	```

## Documentation

For detailed usage, script explanations, and troubleshooting, see the following:
- [help.md](docs/help.md) (English)
- [help-zh.md](docs/help-zh.md) (中文)

## Directory Structure

- `scripts/` — All management and helper scripts
- `config/` — Configuration files
- `log/` — Log files
- `docs/` — Documentation
- `lang/` — Language JSON files for multi-language support

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

