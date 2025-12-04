#!/bin/bash
# Exemplo de uso do gerenciador de pacotes hbk

echo "======================================"
echo "  HubbleOS Package Manager (hbk)"
echo "  Guia de Uso"
echo "======================================"
echo ""

echo "1. Inicializar o gerenciador:"
echo "   python3 /workspaces/HubbleOS/tools/hbk.py init"
echo ""

echo "2. Instalar um pacote local (.tar.gz):"
echo "   python3 /workspaces/HubbleOS/tools/hbk.py install /caminho/pacote.tar.gz"
echo ""

echo "3. Listar pacotes instalados:"
echo "   python3 /workspaces/HubbleOS/tools/hbk.py list"
echo ""

echo "4. Remover um pacote:"
echo "   python3 /workspaces/HubbleOS/tools/hbk.py remove nome-do-pacote"
echo ""

echo "5. Instalar via Nix (se disponível):"
echo "   python3 /workspaces/HubbleOS/tools/hbk.py install vim"
echo ""

echo "======================================"
echo "  Exemplo de pacote personalizado"
echo "======================================"
echo ""

echo "Para criar um pacote:"
echo ""
echo "mkdir -p meu-pacote/bin"
echo "echo '#!/bin/sh' > meu-pacote/bin/meu-script.sh"
echo "chmod +x meu-pacote/bin/meu-script.sh"
echo "tar -czf meu-pacote.tar.gz meu-pacote/"
echo ""
echo "python3 /workspaces/HubbleOS/tools/hbk.py install meu-pacote.tar.gz"
echo ""

echo "Arquivos instalados em: /opt/hubble/packages/"
