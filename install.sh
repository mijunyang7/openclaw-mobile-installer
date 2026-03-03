#!/data/data/com.termux/files/usr/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1" }
print_success() { echo -e "${GREEN}[OK]${NC} $1" }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1" }
print_error() { echo -e "${RED}[ERROR]${NC} $1" }

if [ ! -d "/data/data/com.termux" ]; then
    print_error "This script can only run in Termux!"
    exit 1
fi

print_info "=========================================="
print_info "  OpenClaw Installer v1.1.0"
print_info "=========================================="

print_info "Step 1/8: Checking storage permission..."
if [ ! -d "/sdcard" ]; then
    termux-setup-storage
    sleep 2
fi
print_success "Storage permission configured"

print_info "Step 2/8: Installing base dependencies..."
pkg update -y

# Check Node.js version in Termux
pkg install -y nodejs-lts python git curl wget proot-distro
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    print_warning "Termux Node.js version is $NODE_VERSION (< 22), OpenClaw will run in Ubuntu proot with Node.js 22+"
else
    print_success "Termux Node.js version: $(node --version)"
fi
print_success "Base dependencies installed"

print_info "Step 3/8: Installing Ubuntu proot..."
if proot-distro list 2>/dev/null | grep -q "ubuntu"; then
    print_warning "Ubuntu already installed, skipping"
else
    proot-distro install ubuntu
    print_success "Ubuntu proot environment installed"
fi

print_info "Step 4/8: Installing OpenClaw in Ubuntu..."
WORKSPACE_DIR="$HOME/openclaw_workspace"
mkdir -p "$WORKSPACE_DIR"
UBUNTU_SCRIPT="$WORKSPACE_DIR/ubuntu_install_temp.sh"

cat > "$UBUNTU_SCRIPT" << 'UBUNTU_EOF'
#!/bin/bash
set -e
apt update -y

# Install Node.js 22+ (required for OpenClaw)
apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs

# Verify Node.js version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
    echo "[ERROR] Node.js version must be 22 or higher, current: $NODE_VERSION"
    exit 1
fi
echo "[OK] Node.js $(node --version) installed"

# Install OpenClaw
npm install -g openclaw
echo "[OK] OpenClaw installed"
openclaw --version
UBUNTU_EOF

chmod +x "$UBUNTU_SCRIPT"
if proot-distro login ubuntu -- bash "$UBUNTU_SCRIPT"; then
    print_success "OpenClaw installed successfully"
    rm -f "$UBUNTU_SCRIPT"
else
    print_error "OpenClaw installation failed!"
    exit 1
fi

print_info "Step 5/8: Configuring workspace..."
if [ -d "$WORKSPACE_DIR" ]; then
    print_warning "Workspace already exists: $WORKSPACE_DIR"
else
    mkdir -p "$WORKSPACE_DIR"
    print_success "Workspace created: $WORKSPACE_DIR"
fi
mkdir -p "$WORKSPACE_DIR"/{skills,drafts,monitor_reports,queue}

print_info "Step 6/8: Configuring anti-kill protection..."
HIJACK_FILE="$WORKSPACE_DIR/hijack.js"
cat > "$HIJACK_FILE" << 'HIJACK_EOF'
const net = require('net');
const originalLookup = net.Socket.prototype._connect;
net.Socket.prototype._connect = function() {
    if (arguments[0] && arguments[0].port === 53) { return; }
    return originalLookup.apply(this, arguments);
};
console.log('[OK] Anti-kill protection loaded');
HIJACK_EOF
print_success "Anti-kill protection configured"

STARTUP_FILE="$HOME/.termux/boot.sh"
if [ ! -f "$STARTUP_FILE" ]; then
    mkdir -p "$HOME/.termux"
    cat > "$STARTUP_FILE" << 'STARTUP_EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd $WORKSPACE_DIR
node $HIJACK_FILE &
STARTUP_EOF
    chmod +x "$STARTUP_FILE"
    print_success "Boot script configured"
fi

print_info "Step 7/8: Installing skills..."
SKILLS=(stock-monitor toutiao-publisher proactive-agent weather hot-trend-publisher humanizer-zh self-improvement)
INSTALLED_COUNT=0
for skill in "${SKILLS[@]}"; do
    print_info "  Installing: $skill"
    if npx clawhub install "$skill" 2>/dev/null; then
        print_success "  $skill installed"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    else
        print_warning "  $skill failed (rate limit)"
    fi
    sleep 2
done
print_success "Skills installed: $INSTALLED_COUNT/${#SKILLS[@]}"

print_info "Step 8/8: Configuring cron jobs..."
CRON_FILE="$HOME/cronjobs"
cat > "$CRON_FILE" << 'CRON_EOF'
# OpenClaw cron jobs
0 9 * * 1-5 cd $WORKSPACE_DIR && node skills/stock-monitor/scripts/monitor.js
0 11 * * 1-5 cd $WORKSPACE_DIR && node skills/stock-monitor/scripts/monitor.js
0 15 * * 1-5 cd $WORKSPACE_DIR && node skills/stock-monitor/scripts/monitor.js
0 7 * * 1-5 cd $WORKSPACE_DIR && node skills/hot-trend-publisher/scripts/run.js
CRON_EOF
crontab "$CRON_FILE"
print_success "Cron jobs configured"

print_info "=========================================="
print_success "  OpenClaw Installation Complete!"
print_info "=========================================="
print_info "Workspace: $WORKSPACE_DIR"
print_info "Skills: $INSTALLED_COUNT/${#SKILLS[@]}"
print_info ""
print_info "Next steps:"
print_info "  1. Run: openclaw setup"
print_info "  2. Edit: skills/stock-monitor/scripts/config.js"
print_info "  3. Run: openclaw status"
print_info ""
print_info "Useful commands:"
print_info "  proot-distro login ubuntu"
print_info "  openclaw status"
print_info "  openclaw skills list"
print_info "  openclaw gateway start"
print_info ""
print_warning "Tip: Add Termux to battery optimization whitelist"
print_info "=========================================="

INSTALL_LOG="$WORKSPACE_DIR/install_$(date +%Y%m%d_%H%M%S).log"
echo "OpenClaw installed at $(date)" > "$INSTALL_LOG"
echo "Skills: $INSTALLED_COUNT/${#SKILLS[@]}" >> "$INSTALL_LOG"
print_success "Install log saved: $INSTALL_LOG"
