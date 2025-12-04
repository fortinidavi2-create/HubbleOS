#!/bin/bash
# Guia rápido - Execute este script para setup inicial

echo "======================================"
echo "    HubbleOS - Quick Start Guide"
echo "======================================"
echo ""

echo "[1] Verificando estrutura do projeto..."
ls -la /workspaces/HubbleOS/

echo ""
echo "[2] Verificando se o kernel está presente..."
if [ -d "/workspaces/HubbleOS/linux" ]; then
    echo "✓ Kernel encontrado!"
    du -sh /workspaces/HubbleOS/linux
else
    echo "✗ Kernel não encontrado. Clone o kernel do Linux em /workspaces/HubbleOS/linux"
fi

echo ""
echo "[3] Status das ferramentas:"
echo "   Shell hbsh:" 
[ -f "/workspaces/HubbleOS/tools/hbsh/hbsh" ] && echo "   ✓ Compilado" || echo "   ✗ Não compilado"

echo "   Gerenciador hbk:"
[ -f "/workspaces/HubbleOS/tools/hbk.py" ] && echo "   ✓ Pronto" || echo "   ✗ Não encontrado"

echo ""
echo "[4] Scripts de build disponíveis:"
ls -1 /workspaces/HubbleOS/scripts/

echo ""
echo "======================================"
echo "   Próximos passos:"
echo "======================================"
echo ""
echo "1. Compilar o kernel:"
echo "   bash /workspaces/HubbleOS/scripts/build_kernel.sh"
echo ""
echo "2. Criar initramfs:"
echo "   bash /workspaces/HubbleOS/scripts/create_initramfs.sh"
echo ""
echo "3. Gerar ISO:"
echo "   bash /workspaces/HubbleOS/scripts/build_iso.sh"
echo ""
echo "4. Ou compilar tudo de uma vez:"
echo "   cd /workspaces/HubbleOS && make all"
echo ""
