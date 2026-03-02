# Tasker OpenClaw 安装器配置

---

## 📋 任务流程

### Profile: OpenClaw 安装启动

**触发条件**：
- 应用启动：OpenClaw Installer

**进入任务**：`Install_OpenClaw`

---

## Task: Install_OpenClaw

### 操作 1：检查 Termux

```
Action: App
Type: Check App
Package: com.termux
Store Result: %termux_installed
```

### 操作 2：如果未安装

```
Action: If
Condition: %termux_installed NOT SET

  Action: Alert
  Type: Popup
  Text: Termux 未安装，即将跳转到下载页面...
  
  Action: Net
  Type: View URL
  URL: https://f-droid.org/packages/com.termux/
  
  Action: Wait
  Seconds: 5
  
  Action: Goto
  Type: Action Label
  Label: Check_Permission
```

### 操作 3：授予权限

```
Action: Label
Name: Check_Permission

Action: App
Type: Get Permission
Permission: Storage
Package: com.termux
```

### 操作 4：执行安装脚本

```
Action: Code
Type: Run Shell
Command: |
  curl -L https://raw.githubusercontent.com/你的用户名/openclaw-mobile-installer/main/install.sh | bash
Timeout: 1800
Background: Off
```

### 操作 5：显示进度

```
Action: Alert
Type: Popup
Text: 安装进行中，预计需要 20 分钟...

Action: Wait
Minutes: 20
```

### 操作 6：验证安装

```
Action: Code
Type: Run Shell
Command: |
  openclaw status
Store Result: %install_result
```

### 操作 7：完成提示

```
Action: If
Condition: %install_result MATCHES .*正常.*

  Action: Alert
  Type: Popup
  Text: ✅ OpenClaw 安装成功！
  
  Action: App
  Type: Launch App
  App: com.termux
  
Else

  Action: Alert
  Type: Popup
  Text: ❌ 安装失败，请联系技术支持
  
End If
```

---

## 📱 APP 界面设计

### 主界面

```
┌─────────────────────────────┐
│                             │
│    🦞 OpenClaw Installer    │
│                             │
│    ┌─────────────────┐     │
│    │                 │     │
│    │  [开始安装]     │     │
│    │                 │     │
│    └─────────────────┘     │
│                             │
│    预计耗时：20 分钟         │
│    需要网络：WiFi 环境       │
│                             │
│    ───────────────────      │
│    技术支持：微信/微信       │
│                             │
└─────────────────────────────┘
```

---

## 🔧 导出为 APK

### 步骤

1. 在 Tasker 中完成任务配置
2. 点击菜单 → More → Export
3. 选择"Export as APK"
4. 设置 APK 名称：`OpenClaw Installer`
5. 设置包名：`com.openclaw.installer`
6. 点击 Export

### 签名

- 可以使用 Tasker 默认签名
- 或者用自己的签名证书

---

## 📦 最终交付

**客户收到的 APK**：
- 文件名：`OpenClaw_Installer_v1.0.apk`
- 大小：约 5-10MB
- 安装后直接点击"开始安装"

**客户操作**：
1. 安装 APK
2. 打开 APP
3. 点击"开始安装"
4. 等待 20 分钟
5. 完成

---

*配置版本：1.0.0*  
*创建时间：2026-03-02*
