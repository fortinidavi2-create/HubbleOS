#!/bin/bash
# Script para gerar ISO bootável do HubbleOS

set -e

BUILD_DIR="/workspaces/HubbleOS/build"
ISO_STAGE_DIR="$BUILD_DIR/iso_stage"
OUTPUT_ISO="$BUILD_DIR/hubbleos.iso"
KERNEL_FILE="$BUILD_DIR/kernel/vmlinuz"
INITRAMFS_FILE="$BUILD_DIR/initramfs.cpio.gz"

echo "[*] Criando ISO bootável..."

# Verificar arquivos necessários
if [ ! -f "$KERNEL_FILE" ]; then
    echo "[!] Erro: kernel não encontrado: $KERNEL_FILE"
    exit 1
fi

if [ ! -f "$INITRAMFS_FILE" ]; then
    echo "[!] Erro: initramfs não encontrado: $INITRAMFS_FILE"
    exit 1
fi

# Preparar estrutura da ISO
rm -rf "$ISO_STAGE_DIR"
mkdir -p "$ISO_STAGE_DIR"/{boot/grub,EFI/BOOT}

# Copiar kernel e initramfs
cp "$KERNEL_FILE" "$ISO_STAGE_DIR/boot/"
cp "$INITRAMFS_FILE" "$ISO_STAGE_DIR/boot/"

# Criar configuração GRUB
cat > "$ISO_STAGE_DIR/boot/grub/grub.cfg" << 'EOF'
set default=0
set timeout=5

menuentry 'HubbleOS' {
    linux /boot/vmlinuz root=/dev/ram0 ro quiet
    initrd /boot/initramfs.cpio.gz
}
EOF

# Criar imagem ISO com GRUB
echo "[*] Gerando ISO com GRUB..."

if command -v grub-mkrescue &> /dev/null; then
    grub-mkrescue -o "$OUTPUT_ISO" "$ISO_STAGE_DIR" 2>/dev/null || {
        echo "[!] grub-mkrescue falhou, tentando xorriso..."
        
        if command -v xorriso &> /dev/null; then
            xorriso -as mkisofs -R -b boot/grub/i386-pc/eltorito.img \
                -no-emul-boot -boot-load-size 4 -boot-info-table \
                -o "$OUTPUT_ISO" "$ISO_STAGE_DIR"
        else
            echo "[!] Nenhuma ferramenta para criar ISO disponível (instale grub-mkrescue ou xorriso)"
            exit 1
        fi
    }
else
    echo "[!] grub-mkrescue não encontrado"
    echo "[*] Tentando xorriso..."
    
    if command -v xorriso &> /dev/null; then
        xorriso -as mkisofs -R -o "$OUTPUT_ISO" "$ISO_STAGE_DIR"
    else
        echo "[!] Erro: instale grub-mkrescue ou xorriso"
        exit 1
    fi
fi

echo "[✓] ISO criada com sucesso: $OUTPUT_ISO"
ls -lh "$OUTPUT_ISO"

echo ""
echo "Para testar com QEMU:"
echo "  qemu-system-x86_64 -cdrom $OUTPUT_ISO -m 256"
