# OpenClaw Mobile Installer

📱 一键安装 OpenClaw 到 Android 手机（Termux 环境）

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Termux](https://img.shields.io/badge/Termux-Android-blue)](https://termux.dev/)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-v2026.2-green)](https://openclaw.ai/)

---

## 🚀 快速开始

**一条命令完成安装**：

```bash
curl -L https://raw.githubusercontent.com/你的用户名/openclaw-mobile-installer/main/install.sh | bash
```

或者使用备用链接：

```bash
wget -O install.sh https://raw.githubusercontent.com/你的用户名/openclaw-mobile-installer/main/install.sh
bash install.sh
```

---

## 📋 功能特性

| 功能 | 说明 |
|------|------|
| ✅ **全自动安装** | 一条命令完成所有配置 |
| ✅ **防杀停配置** | 自动配置 hijack.js 防止被系统杀进程 |
| ✅ **Ubuntu 环境** | 安装 proot-distro Ubuntu，更稳定 |
| ✅ **常用技能** | 预装 7 个常用技能 |
| ✅ **定时任务** | 自动配置股票监控、热点发布等定时任务 |
| ✅ **安装日志** | 自动保存安装日志，方便排查问题 |

---

## 🔧 系统要求

| 要求 | 说明 |
|------|------|
| **系统** | Android 7.0+ |
| **存储** | 至少 2GB 可用空间 |
| **内存** | 建议 4GB+ |
| **网络** | WiFi 环境（下载量约 500MB） |
| **APP** | Termux（从 F-Droid 下载） |

---

## 📖 安装步骤

### 1. 安装 Termux

从 F-Droid 下载：https://f-droid.org/packages/com.termux/

⚠️ **不要从 Google Play 下载**，版本过旧！

### 2. 授予权限

打开 Termux，输入：

```bash
termux-setup-storage
```

点击"允许"授予存储权限。

### 3. 运行安装脚本

```bash
curl -L https://raw.githubusercontent.com/你的用户名/openclaw-mobile-installer/main/install.sh | bash
```

### 4. 等待安装完成

预计耗时：**15-20 分钟**

### 5. 验证安装

```bash
openclaw status
```

---

## 📦 预装技能

| 技能 | 说明 |
|------|------|
| stock-monitor | A 股持仓自动监控 |
| toutiao-publisher | 头条号自动发布 |
| proactive-agent | 主动发现机会 |
| weather | 天气查询 |
| hot-trend-publisher | 热点追踪发布 |
| humanizer-zh | AI 文本汉化 |
| self-improvement | 自我改进 |

---

## ⚙️ 常用命令

```bash
# 查看状态
openclaw status

# 查看技能列表
openclaw skills list

# 启动网关
openclaw gateway start

# 停止网关
openclaw gateway stop

# 查看定时任务
crontab -l
```

---

## 🔍 故障排查

### 安装中断

重新运行脚本即可，会自动跳过已完成的部分：

```bash
bash install.sh
```

### 权限不足

确保授予了 Termux 存储权限：
- 手机设置 → 应用管理 → Termux → 权限 → 存储 → 允许

### 进程被杀

将 Termux 加入电池优化白名单：
- 手机设置 → 电池 → 电池优化 → Termux → 不优化

### 网络问题

检查网络连接，或切换到 WiFi 环境重试。

---

## 📚 文档

| 文档 | 说明 |
|------|------|
| [安装指南](客户安装指南.md) | 详细的安装步骤说明 |
| [运行演示](运行演示.md) | 安装过程的模拟输出 |
| [常见问题](FAQ.md) | 常见问题解答 |

---

## 🤝 技术支持

- **问题反馈**：GitHub Issues
- **讨论交流**：GitHub Discussions
- **技术支持**：微信/QQ（购买后提供）

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [OpenClaw](https://openclaw.ai/) - AI 个人助理框架
- [Termux](https://termux.dev/) - Android 终端模拟器

---

**📱 让你的手机跑起 AI 助理！**
