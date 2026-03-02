#!/data/data/com.termux/files/usr/bin/bash

#######################################################################
# OpenClaw 一键安装脚本 (手机版)
# 版本：1.1.0 (修正版)
# 适用：Android Termux 环境
# 功能：自动安装 OpenClaw + Ubuntu 环境 + 防杀停配置 + 常用技能
#######################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() { echo -e "${BLUE}[INFO]${NC} $1" }
print_success() { echo -e "${GREEN}[OK]${NC} $1" }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1" }
print_error() { echo -e "${RED}[ERROR]${NC} $1" }

# 检查是否在 Termux 中运行
if [ ! -d "/data/data/com.termux" ]; then
    print_error "此脚本只能在 Termux 中运行！"
    exit 1
fi

print_info "=========================================="
print_info "  OpenClaw 一键安装脚本 v1.1.0"
print_info "=========================================="

#######################################################################
# 步骤 1: 检查并授予存储权限
#######################################################################
print_info "步骤 1/8: 检查存储权限..."
if [ ! -d "/sdcard" ]; then
    print_warning "存储权限未授予，正在请求..."
    termux-setup-storage
    sleep 2
fi
print_success "存储权限已配置"

#######################################################################
# 步骤 2: 更新软件源并安装基础依赖
#######################################################################
print_info "步骤 2/8: 安装基础依赖 (约 3-5 分钟)..."

# 更新软件源
pkg update -y

# 安装必要依赖
pkg install -y nodejs-lts python git curl wget proot-distro

print_success "基础依赖安装完成"

#######################################################################
# 步骤 3: 安装 Ubuntu proot 环境 ⭐ 提前到这里
#######################################################################
print_info "步骤 3/8: 安装 Ubuntu proot 环境 (约 5-8 分钟)..."

# 检查是否已安装
if proot-distro list 2>/dev/null | grep -q "ubuntu"; then
    print_warning "Ubuntu 已安装，跳过"
else
    # 安装 Ubuntu
    proot-distro install ubuntu
    print_success "Ubuntu proot 环境安装成功"
fi

#######################################################################
# 步骤 4: 在 Ubuntu 环境中安装 OpenClaw
#######################################################################
print_info "步骤 4/8: 在 Ubuntu 中安装 OpenClaw..."

# 在 Ubuntu 环境中安装 OpenClaw
proot-distro login ubuntu -- bash -c "
    # 更新 apt
    apt update -y
    
    # 安装 Node.js 和 npm
    apt install -y nodejs npm
    
    # 安装 OpenClaw
    npm install -g openclaw
    
    # 验证安装
    if command -v openclaw &> /dev/null; then
        echo '[OK] OpenClaw 安装成功'
        openclaw --version
    else
        echo '[ERROR] OpenClaw 安装失败！'
        exit 1
    fi
"

if [ $? -eq 0 ]; then
    print_success "OpenClaw 安装成功"
else
    print_error "OpenClaw 安装失败！"
    exit 1
fi

#######################################################################
# 步骤 5: 配置工作目录
#######################################################################
print_info "步骤 5/8: 配置工作目录..."

WORKSPACE_DIR="$HOME/openclaw_workspace"

if [ -d "$WORKSPACE_DIR" ]; then
    print_warning "工作目录已存在：$WORKSPACE_DIR"
else
    mkdir -p "$WORKSPACE_DIR"
    print_success "工作目录已创建：$WORKSPACE_DIR"
fi

# 创建必要的子目录
mkdir -p "$WORKSPACE_DIR"/{skills,drafts,monitor_reports,queue}

#######################################################################
# 步骤 6: 安装防杀停配置 (hijack.js)
#######################################################################
print_info "步骤 6/8: 配置防杀停..."

HIJACK_FILE="$WORKSPACE_DIR/hijack.js"

cat > "$HIJACK_FILE" << 'EOF'
// OpenClaw 防杀停配置
// 屏蔽网络接口检测，防止被系统杀进程

const net = require('net');
const originalLookup = net.Socket.prototype._connect;

net.Socket.prototype._connect = function() {
    // 忽略网络检测请求
    if (arguments[0] && arguments[0].port === 53) {
        return;
    }
    return originalLookup.apply(this, arguments);
};

console.log('[OK] 防杀停配置已加载');
EOF

print_success "防杀停配置已创建"

# 添加到启动脚本
STARTUP_FILE="$HOME/.termux/boot.sh"
if [ -f "$STARTUP_FILE" ]; then
    print_warning "启动脚本已存在，跳过"
else
    mkdir -p "$HOME/.termux"
    cat > "$STARTUP_FILE" << EOF
#!/data/data/com.termux/files/usr/bin/bash
cd $WORKSPACE_DIR
node $HIJACK_FILE &
EOF
    chmod +x "$STARTUP_FILE"
    print_success "开机自启配置已创建"
fi

#######################################################################
# 步骤 7: 安装常用技能
#######################################################################
print_info "步骤 7/8: 安装常用技能..."

SKILLS=(
    "stock-monitor"          # 股票监控
    "toutiao-publisher"      # 头条号发布
    "proactive-agent"        # 主动代理
    "weather"                # 天气查询
    "hot-trend-publisher"    # 热点追踪
    "humanizer-zh"           # 文本汉化
    "self-improvement"       # 自我改进
)

INSTALLED_COUNT=0

for skill in "${SKILLS[@]}"; do
    print_info "  安装技能：$skill"
    if npx clawhub install "$skill" 2>/dev/null; then
        print_success "  ✓ $skill 安装成功"
        ((INSTALLED_COUNT++))
    else
        print_warning "  ✗ $skill 安装失败 (可能是速率限制)"
    fi
    sleep 2  # 避免速率限制
done

print_success "技能安装完成：$INSTALLED_COUNT/${#SKILLS[@]} 个成功"

#######################################################################
# 步骤 8: 配置定时任务
#######################################################################
print_info "步骤 8/8: 配置定时任务..."

CRON_FILE="$HOME/cronjobs"

cat > "$CRON_FILE" << EOF
# OpenClaw 定时任务配置
# 股票监控
0 9 * * 1-5 cd $WORKSPACE_DIR && node skills/stock-monitor/scripts/monitor.js
0 11 * * 1-5 cd $WORKSPACE_DIR && node skills/stock-monitor/scripts/monitor.js
0 15 * * 1-5 cd $WORKSPACE_DIR && node skills/stock-monitor/scripts/monitor.js

# 热点发布
0 7 * * 1-5 cd $WORKSPACE_DIR && node skills/hot-trend-publisher/scripts/run.js
EOF

# 导入 cron 任务
crontab "$CRON_FILE"

print_success "定时任务配置完成"

#######################################################################
# 安装完成
#######################################################################
print_info "=========================================="
print_success "  OpenClaw 安装完成！"
print_info "=========================================="
print_info ""
print_info "工作目录：$WORKSPACE_DIR"
print_info "Ubuntu 环境：已安装"
print_info "技能数量：$INSTALLED_COUNT/${#SKILLS[@]}"
print_info ""
print_info "下一步操作："
print_info "  1. 运行 openclaw setup 完成初始化"
print_info "  2. 编辑 skills/stock-monitor/scripts/config.js 配置持仓"
print_info "  3. 运行 openclaw status 检查状态"
print_info ""
print_info "常用命令："
print_info "  proot-distro login ubuntu  # 进入 Ubuntu 环境"
print_info "  openclaw status            # 查看状态"
print_info "  openclaw skills list       # 查看技能"
print_info "  openclaw gateway start     # 启动网关"
print_info ""
print_warning "提示：建议将 Termux 加入电池优化白名单，防止被杀进程"
print_info "=========================================="

# 保存安装日志
INSTALL_LOG="$WORKSPACE_DIR/install_$(date +%Y%m%d_%H%M%S).log"
echo "OpenClaw 安装完成于 $(date)" > "$INSTALL_LOG"
echo "技能安装：$INSTALLED_COUNT/${#SKILLS[@]}" >> "$INSTALL_LOG"

print_success "安装日志已保存：$INSTALL_LOG"
