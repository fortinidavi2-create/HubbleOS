#!/bin/bash
# Script para compilar o kernel Linux

set -e

KERNEL_DIR="/workspaces/HubbleOS/linux"
BUILD_DIR="/workspaces/HubbleOS/build"
OUTPUT_DIR="$BUILD_DIR/kernel"

echo "[*] Compilando Linux Kernel..."

if [ ! -d "$KERNEL_DIR" ]; then
    echo "[!] Erro: diretório do kernel não encontrado: $KERNEL_DIR"
    exit 1
fi

# Criar diretório de saída
mkdir -p "$OUTPUT_DIR"

# Copiar configuração padrão (x86_64)
cd "$KERNEL_DIR"

# Use uma configuração minimal
if [ -f "arch/x86/configs/x86_64_defconfig" ]; then
    cp "arch/x86/configs/x86_64_defconfig" .config
elif [ -f ".config" ]; then
    echo "[*] Usando .config existente"
else
    echo "[*] Gerando configuração padrão..."
    make defconfig
fi

# Adaptar configuração para nosso uso
./scripts/config --enable CONFIG_ELF_CORE
./scripts/config --enable CONFIG_BLK_DEV_INITRD
./scripts/config --enable CONFIG_INITRAMFS_SOURCE

echo "[*] Compilando kernel (isto pode levar 10-30 minutos)..."

# Compilar (ajuste -j4 ao número de CPUs disponíveis)
make -j$(nproc) bzImage

# Copiar output
cp arch/x86/boot/bzImage "$OUTPUT_DIR/vmlinuz"
cp System.map "$OUTPUT_DIR/System.map"
cp .config "$OUTPUT_DIR/kernel.config"

echo "[✓] Kernel compilado em: $OUTPUT_DIR"
echo "[*] Saídas:"
echo "    - $OUTPUT_DIR/vmlinuz"
echo "    - $OUTPUT_DIR/System.map"
echo "    - $OUTPUT_DIR/kernel.config"
