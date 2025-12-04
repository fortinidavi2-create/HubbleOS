#!/bin/bash
set -e

BUILD_DIR="/workspaces/HubbleOS/build"
ISO_STAGE="$BUILD_DIR/iso_stage"
OUTPUT_ISO="$BUILD_DIR/hubbleos-final.iso"

echo "[*] Preparando ISO bootável HubbleOS..."

# Limpar stage
rm -rf "$ISO_STAGE"
mkdir -p "$ISO_STAGE"/{boot/grub,EFI/BOOT}

# Copiar kernel (tentar build primeiro, depois fallback)
if [ -f "$BUILD_DIR/kernel/vmlinuz" ]; then
    echo "[✓] Usando kernel compilado"
    cp "$BUILD_DIR/kernel/vmlinuz" "$ISO_STAGE/boot/"
elif [ -f "/boot/vmlinuz-$(uname -r)" ]; then
    echo "[✓] Usando kernel do sistema"
    cp "/boot/vmlinuz-$(uname -r)" "$ISO_STAGE/boot/vmlinuz"
else
    echo "[!] Nenhum kernel encontrado!"
    exit 1
fi

# Copiar initramfs
if [ -f "$BUILD_DIR/initramfs.cpio.gz" ]; then
    echo "[✓] Initramfs encontrado"
    cp "$BUILD_DIR/initramfs.cpio.gz" "$ISO_STAGE/boot/"
else
    echo "[!] Initramfs não encontrado"
    exit 1
fi

# Criar GRUB config
cat > "$ISO_STAGE/boot/grub/grub.cfg" << 'EOF'
set default=0
set timeout=5

menuentry 'HubbleOS' {
    linux /boot/vmlinuz root=/dev/ram0 rw quiet splash
    initrd /boot/initramfs.cpio.gz
}

menuentry 'HubbleOS (verbose)' {
    linux /boot/vmlinuz root=/dev/ram0 rw
    initrd /boot/initramfs.cpio.gz
}

menuentry 'HubbleOS (rescue)' {
    linux /boot/vmlinuz root=/dev/ram0 rw single
    initrd /boot/initramfs.cpio.gz
}
EOF

echo "[✓] Configuração GRUB criada"

# Criar ISO
echo "[*] Gerando ISO bootável..."

if command -v grub-mkrescue &> /dev/null; then
    echo "[*] Usando grub-mkrescue..."
    sudo grub-mkrescue -o "$OUTPUT_ISO" "$ISO_STAGE" 2>&1 | grep -v "^xorriso" || true
elif command -v xorriso &> /dev/null; then
    echo "[*] Usando xorriso..."
    xorriso -as mkisofs -R -J -l -iso-level 3 -o "$OUTPUT_ISO" "$ISO_STAGE"
elif command -v mkisofs &> /dev/null; then
    echo "[*] Usando mkisofs..."
    mkisofs -R -J -l -iso-level 3 -o "$OUTPUT_ISO" "$ISO_STAGE"
else
    echo "[!] Nenhuma ferramenta de ISO encontrada!"
    exit 1
fi

if [ -f "$OUTPUT_ISO" ]; then
    echo "[✓✓✓] ISO CRIADA COM SUCESSO! [✓✓✓]"
    echo ""
    echo "Localização: $OUTPUT_ISO"
    ls -lh "$OUTPUT_ISO"
    echo ""
    echo "Para testar com QEMU:"
    echo "  qemu-system-x86_64 -cdrom $OUTPUT_ISO -m 512"
else
    echo "[!] Erro ao criar ISO"
    exit 1
fi
