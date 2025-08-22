# 饥荒联机版专用服务器脚本

# [English](../README.md) | [中文](README-zh.md)

本项目提供了一套 Shell 脚本，用于在 Linux 上自动化安装、配置、管理和更新饥荒联机版（DST）专用服务器。

Fork 自 [cuukenn/dontstarveserver](https://github.com/cuukenn/dontstarveserver)。新增了模组管理、自动生成模组配置文件，并提升了代码可读性。

## 功能特性

- 自动化环境搭建与依赖安装
- 用户与权限管理
- 便捷的服务器启动、停止、重启与更新
- 模组管理与自动生成模组配置文件（新增）
- 支持主世界与洞穴分片
- 支持自动更新的定时任务（cron）
- 清晰的日志与配置管理
- 多语言支持（英文/中文），通过 `LANGUAGE` 配置和 .properties 消息文件切换

## 快速开始

1. **克隆或复制本仓库到服务器。**
2. **编辑 `config/config.properties`，根据实际环境和需求修改。**
   - 如需切换语言，设置 `LANGUAGE=en`（英文，默认）或 `LANGUAGE=zh`（中文）。
3. **以 root 或 sudo 运行初始化脚本：**
   ```bash
   ./setup.sh
   ```
4. **在本地创建带模组的存档并上传到服务器：**
   ```
   # 例如使用 scp 命令上传存档和模组：
   scp -r <CLUSTER_PATH>/ <DST_USER>@<HOST>:~/.klei/DoNotStarveTogether/
   ```
5. **切换到 DST 用户并启动服务器：**
   ```bash
   su <DST_USER>
   cd ~/<DST_SCRIPT_PATH>
   ./start.sh
   ```

## 目录结构

- `scripts/` — 所有管理与辅助脚本
- `config/` — 配置文件
- `log/` — 日志文件
- `docs/` — 文档
- `lang/` — 多语言 .properties 文件

## 多语言支持


所有用户提示信息均通过 `lang/` 目录下的 .properties 文件本地化。通过 `config/config.properties` 中的 `LANGUAGE` 变量选择语言。

可在 `lang/en.properties`（英文）和 `lang/zh.properties`（中文）中添加或编辑消息。要添加更多语言，在 `lang/` 目录下新建对应的 .properties 文件并设置 `LANGUAGE`。

## 文档

详细用法、脚本说明和故障排查请参见 [help-zh.md](docs/help-zh.md)。

## 许可证

本项目采用 MIT 许可证，详见 `LICENSE` 文件。
