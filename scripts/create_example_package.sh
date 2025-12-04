#!/bin/bash
# Criar exemplo de pacote para hbk

set -e

PACKAGES_DIR="/workspaces/HubbleOS/packages"
EXAMPLE_PKG="$PACKAGES_DIR/example-tools"

echo "[*] Criando pacote exemplo (example-tools)..."

mkdir -p "$EXAMPLE_PKG/bin"
mkdir -p "$EXAMPLE_PKG/share/doc"

# Adicionar alguns scripts de exemplo
cat > "$EXAMPLE_PKG/bin/hello.sh" << 'EOF'
#!/bin/sh
echo "Olá do HubbleOS!"
echo "Versão: 1.0"
EOF

cat > "$EXAMPLE_PKG/bin/sysinfo.sh" << 'EOF'
#!/bin/sh
echo "=== HubbleOS System Info ==="
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "CPU Cores: $(nproc)"
echo "Uptime: $(uptime)"
EOF

chmod +x "$EXAMPLE_PKG/bin"/*.sh

# Adicionar documentação
cat > "$EXAMPLE_PKG/share/doc/README" << 'EOF'
# Example Tools Package for HubbleOS

Pacote de exemplo contendo scripts úteis para HubbleOS.

## Scripts inclusos:
- bin/hello.sh     - Imprime mensagem de boas-vindas
- bin/sysinfo.sh   - Mostra informações do sistema

## Instalação:
  hbk install example-tools.tar.gz

## Uso:
  /opt/hubble/packages/example-tools/bin/hello.sh
  /opt/hubble/packages/example-tools/bin/sysinfo.sh
EOF

# Criar tarball
cd "$PACKAGES_DIR"
tar -czf example-tools.tar.gz example-tools/

echo "[✓] Pacote criado: $PACKAGES_DIR/example-tools.tar.gz"
ls -lh "$PACKAGES_DIR/example-tools.tar.gz"
