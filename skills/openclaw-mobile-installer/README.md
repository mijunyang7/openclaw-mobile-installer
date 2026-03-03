# OpenClaw 手机版安装指南

## 📱 适用设备

- **系统**：Android 7.0+
- **存储**：至少 2GB 可用空间
- **内存**：建议 4GB+
- **网络**：WiFi 环境（下载量约 500MB）

---

## 🔧 安装步骤

### 步骤 1：安装 Termux

**下载地址**（任选其一）：

1. **F-Droid（推荐）**：https://f-droid.org/packages/com.termux/
2. **GitHub**：https://github.com/termux/termux-app/releases

⚠️ **重要**：不要从 Google Play 下载，版本过旧！

### 步骤 2：打开 Termux 并授予权限

1. 打开 Termux APP
2. 输入以下命令授予存储权限：
   ```bash
   termux-setup-storage
   ```
3. 点击"允许"授予存储权限

### 步骤 3：下载并运行安装脚本

复制以下命令并粘贴到 Termux 中：

```bash
curl -L https://raw.githubusercontent.com/mijunyang7/openclaw-mobile-installer/main/install.sh | bash
```

或者（如果上面失败）：

```bash
wget https://raw.githubusercontent.com/your-repo/openclaw-mobile-installer/main/install.sh -O install.sh
bash install.sh
```

### 步骤 4：等待安装完成

脚本会自动完成以下操作：

- ✅ 安装 Node.js、Python 等依赖
- ✅ 安装 OpenClaw
- ✅ 配置防杀停
- ✅ 安装 Ubuntu 环境
- ✅ 安装 7 个常用技能
- ✅ 配置定时任务

**预计耗时**：15-20 分钟

### 步骤 5：验证安装

安装完成后，运行以下命令验证：

```bash
openclaw status
```

如果看到正常输出，说明安装成功！

---

## ⚙️ 常用命令

| 命令 | 说明 |
|------|------|
| `openclaw status` | 查看状态 |
| `openclaw skills list` | 查看已安装技能 |
| `openclaw gateway start` | 启动网关 |
| `openclaw gateway stop` | 停止网关 |
| `crontab -l` | 查看定时任务 |

---

## 🔍 常见问题

### Q1: Node.js 版本太低？

**A**: v1.1.1 已修复！脚本会自动安装 Node.js 22+ 到 Ubuntu proot 环境，不受 Termux 自带 Node.js 版本影响。

**OpenClaw 要求**: Node.js 22+

如果遇到版本错误，请重新运行：
```bash
bash install.sh
```

### Q2: 安装过程中断怎么办？

**A**: 重新运行安装脚本即可，脚本会跳过已安装的组件：
```bash
bash install.sh
```

### Q2: 提示"权限不足"？

**A**: 确保授予了 Termux 存储权限：
- 手机设置 → 应用管理 → Termux → 权限 → 存储 → 允许

### Q3: 进程被系统杀掉？

**A**: 将 Termux 加入电池优化白名单：
- 手机设置 → 电池 → 电池优化 → Termux → 不优化

### Q4: 技能安装失败？

**A**: 可能是网络问题或速率限制，稍后重试：
```bash
npx clawhub install 技能名
```

### Q5: 开机后需要手动启动？

**A**: 是的，打开 Termux APP 即可，定时任务会自动运行。

---

## 📞 技术支持

- **支持期限**：购买后 30 天
- **支持方式**：微信/QQ 远程协助
- **响应时间**：工作日 24 小时内

---

## 📚 进阶使用

### 配置股票监控

编辑持仓配置文件：
```bash
cd ~/openclaw_workspace
# 使用文本编辑器配置持仓
```

### 配置头条号发布

编辑头条号配置文件：
```bash
cd ~/openclaw_workspace/skills/toutiao-publisher
# 配置账号信息
```

### 添加新技能

```bash
npx clawhub install 技能名
```

---

*版本：1.0.0*  
*更新日期：2026-03-02*
