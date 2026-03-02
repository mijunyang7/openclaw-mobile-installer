#!/data/data/com.termux/files/usr/bin/bash
set -e
echo "=== OpenClaw Installer ==="
[ ! -d "/sdcard" ] && termux-setup-storage
pkg update -y && pkg install -y nodejs-lts python git proot-distro -y
proot-distro list 2>/dev/null | grep -q ubuntu || proot-distro install ubuntu
WORKSPACE="$HOME/openclaw_workspace"
mkdir -p "$WORKSPACE"
cat > "$WORKSPACE/ubuntu.sh" << 'UBEOF'
#!/bin/bash
apt update -y && apt install -y nodejs npm && npm install -g openclaw
UBEOF
chmod +x "$WORKSPACE/ubuntu.sh"
proot-distro login ubuntu -- bash "$WORKSPACE/ubuntu.sh"
rm -f "$WORKSPACE/ubuntu.sh"
echo "=== Complete! Run: openclaw setup ==="
