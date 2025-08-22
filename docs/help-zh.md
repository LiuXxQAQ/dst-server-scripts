# 饥荒联机版服务器管理 - 帮助

## 概述

本项目提供了一套 Shell 脚本，用于在 Linux 上自动化安装、配置、启动、关闭和更新饥荒联机版（DST）专用服务器。

## 主要脚本与用法

### 1. `setup.sh`
初始化环境，安装依赖，创建 DST 用户，配置 SteamCMD 并复制脚本。
```bash
./setup.sh
```

### 2. `start.sh`
启动 DST 主服务器和（如启用）洞穴服务器。
```bash
./start.sh
```

### 3. `stop.sh`
停止主服务器和洞穴服务器。
```bash
./stop.sh
```

### 4. `restart.sh`
重启服务器，可选地更新服务器文件。
```bash
./restart.sh [update]
# [update]: 1 表示更新服务器文件，0（默认）仅重启
```

### 5. `update.sh`
重启服务器并触发更新。
```bash
./update.sh
```

### 6. `scripts/dst-start.sh`
启动指定分片（主服务器或洞穴）。
```bash
./scripts/dst-start.sh <server_type> [cluster_name]
# <server_type>: Master 或 Caves
# [cluster_name]: 可选，默认为配置中的值
```

### 7. `scripts/dst-stop.sh`
停止指定分片。
```bash
./scripts/dst-stop.sh <server_type> [cluster_name] [signal]
# <server_type>: Master 或 Caves
# [cluster_name]: 可选，默认为配置中的值
# [signal]: 可选，默认 5 (SIGTRAP)
```

### 8. `scripts/setup-dst-mods.sh`
根据 `modoverrides.lua` 生成模组配置文件。
```bash
./scripts/setup-dst-mods.sh <DST_CLUSTER_NAME> <DST_SERVER_PATH>
```

如果配置中 `DST_MOD_ENABLE=1`，则在启动服务器前会自动运行此脚本（见 `start.sh`）。

## 配置

编辑 `config/config.properties`，可设置：
- `STEAMCMD_USERNAME`：DST 服务器专用 Linux 用户
- `STEAMCMD_PATH`：SteamCMD 安装目录
- `DST_SCRIPT_PATH`：脚本目录
- `DST_SERVER_PATH`：DST 服务器目录
- `DST_GAME_ID`：DST 游戏 ID（默认 343050）
- `DST_CLUSTER_NAME`：集群名称
- `DST_CAVES_ENABLE`：1 启用洞穴，0 关闭
- `DST_MOD_ENABLE`：1 启用模组（启动前自动生成模组配置），0 关闭
- `LANGUAGE`：`en` 英文（默认），`zh` 中文。控制所有用户提示信息。

## 目录结构

- 脚本：`dst_scripts/`
- 配置：`dst_scripts/config/`
- 日志：`dst_scripts/log/`
- 文档：`dst_scripts/docs/`
- 语言文件：`dst_scripts/lang/`
- DST 服务器：`/home/<user>/<DST_SERVER_PATH>/`
- 存档：`/home/<user>/.Klei/DoNotStarveTogether/<DST_CLUSTER_NAME>/`

## 常用操作

- **安装/初始化：** 以 root 或 sudo 运行 `setup.sh`
- **启动服务器：** 以 DST 用户运行 `start.sh`
- **停止服务器：** 以 DST 用户运行 `stop.sh`
- **重启/更新：** 以 DST 用户运行 `restart.sh` 或 `update.sh`
- **管理模组：** 编辑 `modoverrides.lua` 后运行 `setup-dst-mods.sh`

## 自动更新定时任务

如需每日自动更新，可添加如下 cron 任务：
```bash
crontab -u <DST_USER> /home/<DST_USER>/<DST_SCRIPT_PATH>/config/cron.cmd
```

## 多语言支持

所有用户提示信息均通过 `lang/` 目录下的 JSON 文件本地化。通过 `config/config.properties` 中的 `LANGUAGE` 变量选择语言。

可在 `lang/en.json`（英文）和 `lang/zh.json`（中文）中添加或编辑消息。要添加更多语言，在 `lang/` 目录下新建 JSON 文件并设置 `LANGUAGE`。

## 故障排查

- 检查 `log/` 目录下的日志文件。
- 确保所有依赖已安装（见 `setup-sys-*` 脚本）。
- 确保所有文件和目录的用户权限正确。
