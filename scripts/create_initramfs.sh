#!/bin/bash
# Script para criar initramfs com hbsh e ferramentas

set -e

BUILD_DIR="/workspaces/HubbleOS/build"
TOOLS_DIR="/workspaces/HubbleOS/tools"
INITRAMFS_DIR="$BUILD_DIR/initramfs"
OUTPUT_FILE="$BUILD_DIR/initramfs.cpio.gz"

echo "[*] Criando initramfs..."

# Limpar e criar estrutura
rm -rf "$INITRAMFS_DIR"
mkdir -p "$INITRAMFS_DIR"/{bin,sbin,lib,lib64,usr/{bin,sbin},proc,sys,dev,etc,root,tmp,var/log}

# Copiar hbsh
if [ -f "$TOOLS_DIR/hbsh/hbsh" ]; then
    cp "$TOOLS_DIR/hbsh/hbsh" "$INITRAMFS_DIR/bin/"
    cp "$TOOLS_DIR/hbsh/hbsh" "$INITRAMFS_DIR/bin/sh"
else
    echo "[!] Aviso: hbsh não compilado. Usando sh padrão (busybox recomendado)"
fi

# Copiar BusyBox (se disponível)
if command -v busybox &> /dev/null; then
    cp "$(which busybox)" "$INITRAMFS_DIR/bin/"
    cd "$INITRAMFS_DIR/bin"
    ./busybox --install -s .
    cd -
fi

# Copiar bibliotecas essenciais (libc, libm)
for lib in /lib64/libc.so.6 /lib64/libm.so.6 /lib64/ld-linux-x86-64.so.2; do
    if [ -f "$lib" ]; then
        cp "$lib" "$INITRAMFS_DIR/lib64/" 2>/dev/null || true
    fi
done

# Copiar ferramentas do sistema
for tool in ls cat echo pwd cd mkdir mount umount kill; do
    if command -v $tool &> /dev/null; then
        cp "$(which $tool)" "$INITRAMFS_DIR/bin/" 2>/dev/null || true
    fi
done

# Criar init simples
cat > "$INITRAMFS_DIR/init" << 'EOF'
#!/bin/sh
echo "=== HubbleOS Initramfs ==="
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mkdir -p /dev/pts
mount -t devpts devpts /dev/pts

export PATH=/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin
export HOME=/root
export SHELL=/bin/sh

echo ""
echo "Bem-vindo ao HubbleOS!"
echo "Digite 'help' para comandos disponíveis"
echo ""

exec /bin/sh
EOF
chmod +x "$INITRAMFS_DIR/init"

# Criar initramfs
cd "$INITRAMFS_DIR"
find . | cpio -o -H newc | gzip > "$OUTPUT_FILE"
cd -

echo "[✓] Initramfs criado: $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
