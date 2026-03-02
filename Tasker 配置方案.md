# Tasker OpenClaw 安装器配置

---

## 📋 任务流程

### Profile: OpenClaw 安装启动

**触发条件**：
- 应用启动：OpenClaw Installer

**进入任务**：`Install_OpenClaw`

---

##任务：安装_OpenClaw

### 操作 1：检查 Termux

```
操作：应用
类型：检查应用
软件包：com.termux
存储结果：%termux_installed
```

### 操作 2：如果未安装

```
操作：如果
条件：%termux_installed 未设置

操作：警告
类型：弹出框
文本：Termux 未安装，即将跳转到下载页面...
  
操作：网络
类型：查看网址
网址：https://f-droid.org/packages/com.termux/
  
操作：等待
秒数：5
  
操作：跳转
类型：操作标签
标签：检查权限
```

### 操作 3：授予权限

```
操作：标签
名称：检查权限

操作：应用
类型：获取权限
权限：存储
软件包：com.termux
```

### 操作 4：执行安装脚本

```
操作：代码
类型：运行Shell
命令：|
  curl -L https://raw.githubusercontent.com/mijunyang7/openclaw-mobile-installer/main/install.sh | bash
超时：1800
后台：关
```

### 操作 5：显示进度

```
操作：警告
类型：弹出框
文本：安装进行中，预计需要 20 分钟...

操作：等待
分钟：20
```

### 操作 6：验证安装

```
操作：代码
类型：运行Shell
命令：|
openclaw状态
存储结果： %install_result
```

### 操作 7：完成提示

```
Action: If
条件：%install_result 匹配 .*正常.*

操作：警告
类型：弹出框
  Text: ✅ OpenClaw 安装成功！
  
操作：应用
类型：启动应用
应用：com.termux
  
否则

操作：警告
类型：弹出框
文本：❌ 安装失败，请联系技术支持
  
结束如果
```

---

##APP界面设计

### 主界面

```
┌─────────────────────────────┐
│                             │
│ OpenClaw 安装程序 │
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
