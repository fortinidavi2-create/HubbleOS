#!/bin/bash
# INSTRUÇÕES FINAIS - Leia isto primeiro!

clear

cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║                    🚀 HubbleOS - INSTRUÇÕES FINAIS 🚀                     ║
║                                                                           ║
║              Distribuição Linux Personalizada - Pronta para Build         ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝

Olá! Você agora tem uma estrutura completa de HubbleOS pronta para criar 
uma distribuição Linux personalizada.

📌 O QUE FOI CRIADO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ Shell Personalizado (hbsh) - Compilado e pronto
✓ Gerenciador de Pacotes (hbk) - Com suporte a Nix
✓ Scripts de Build - Para compilar kernel, criar initramfs e ISO
✓ Documentação Completa - BUILD_GUIDE.md, README.md, etc
✓ Kernel Linux - Já presente (~7.6GB)

📂 ARQUIVOS IMPORTANTES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

README.md              ← Leia primeiro (visão geral)
BUILD_GUIDE.md         ← Instruções passo a passo
PROJECT_STATUS.txt    ← Status e estrutura do projeto
PKG_MANAGER_GUIDE.md  ← Como usar o gerenciador hbk

tools/hbsh/           ← Shell compilado + código-fonte
tools/hbk.py          ← Gerenciador de pacotes
scripts/              ← Scripts de build

🚀 PASSO A PASSO - COMO CONSTRUIR HubbleOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OPÇÃO A: Build Completo em Uma Linha
─────────────────────────────────────

    cd /workspaces/HubbleOS
    make all

    Isto fará:
    1. Compilar o kernel (30-60 min)
    2. Criar initramfs (~5 min)
    3. Gerar ISO (~10 min)
    
    Resultado: build/hubbleos.iso


OPÇÃO B: Passo a Passo (Mais controle)
────────────────────────────────────────

    Passo 1: Compilar o kernel
    $ bash scripts/build_kernel.sh
    (Resultado: build/kernel/vmlinuz)

    Passo 2: Criar initramfs
    $ bash scripts/create_initramfs.sh
    (Resultado: build/initramfs.cpio.gz)

    Passo 3: Gerar ISO
    $ bash scripts/build_iso.sh
    (Resultado: build/hubbleos.iso)


OPÇÃO C: Teste Rápido (Sem compilar tudo)
────────────────────────────────────────────

    Testar o shell hbsh:
    $ /workspaces/HubbleOS/tools/hbsh/hbsh
    > pwd
    > help
    > exit

    Testar gerenciador hbk:
    $ python3 /workspaces/HubbleOS/tools/hbk.py init
    $ python3 /workspaces/HubbleOS/tools/hbk.py list

⚠️  IMPORTANTE - REQUISITOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Compilação do Kernel precisa de:
  • 20+ GB de espaço em disco livre
  • Linux host (Ubuntu, Debian, CentOS, etc)
  • gcc, make, binutils instalados
  • 30-60 minutos de tempo

Ferramentas necessárias (instalr se faltarem):

    # Ubuntu/Debian:
    sudo apt-get install build-essential grub-pc xorriso qemu-system

    # RedHat/CentOS:
    sudo yum install gcc make binutils grub2-tools xorriso qemu-system-x86


🎯 ARQUIVOS DE SAÍDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Após o build completo, você terá:

  build/kernel/vmlinuz          ← Kernel compilado
  build/initramfs.cpio.gz       ← Sistema raiz
  build/hubbleos.iso            ← ISO bootável (500MB-1GB)

Testar com QEMU:
    qemu-system-x86_64 -cdrom build/hubbleos.iso -m 512


📦 ADICIONAR FERRAMENTAS (git, gcc, curl, vim, Nix)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Opção 1: BusyBox (Padrão - economiza espaço)
    Fornece versões compactas de ls, cat, echo, etc
    Já incluído automaticamente no initramfs

Opção 2: Via Nix Package Manager
    python3 tools/hbk.py install git
    python3 tools/hbk.py install gcc
    python3 tools/hbk.py install curl
    python3 tools/hbk.py install vim

Opção 3: Copiar binários manualmente
    cp /usr/bin/curl build/initramfs/usr/bin/
    cp /usr/bin/git build/initramfs/usr/bin/
    (Re-executar create_initramfs.sh)


🔧 CUSTOMIZAÇÕES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Adicionar drivers ao kernel:
    cd /workspaces/HubbleOS/linux
    make menuconfig    ← Interface interativa para customizar

Incluir programas customizados:
    cp /seu/programa build/initramfs/bin/
    bash scripts/create_initramfs.sh

Trocar configuração do kernel:
    Editar: scripts/build_kernel.sh
    Alterar: "make defconfig" por "make tinyconfig"


📚 DOCUMENTAÇÃO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BUILD_GUIDE.md
    ├─ Estrutura completa do projeto
    ├─ Explicação de cada componente
    ├─ Troubleshooting
    └─ Customizações avançadas

PKG_MANAGER_GUIDE.md
    ├─ Como usar hbk
    ├─ Instalar pacotes
    └─ Criar pacotes customizados

README.md
    ├─ Visão geral
    └─ Referência rápida


🔍 VERIFICAÇÃO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Verificar estrutura criada:
    ls -la /workspaces/HubbleOS/

Verificar kernel:
    ls -la /workspaces/HubbleOS/linux/ | head -20

Verificar shell compilado:
    file /workspaces/HubbleOS/tools/hbsh/hbsh

Verificar scripts:
    ls -la /workspaces/HubbleOS/scripts/


💡 DICAS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

• Se o espaço for limitado, use "make tinyconfig" no kernel
• Para testar rápido, pule a compilação do kernel (use vmlinuz pré-compilado)
• BusyBox já fornece a maioria dos comandos Unix necessários
• O gerenciador hbk instalará pacotes em /opt/hubble/packages/
• Todos os scripts são editáveis - customize conforme necessário


❓ DÚVIDAS?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Verifique:
  1. BUILD_GUIDE.md - Guia completo
  2. PROJECT_STATUS.txt - Status detalhado
  3. Scripts com comentários em scripts/*.sh

═══════════════════════════════════════════════════════════════════════════

Tudo pronto! Comece com um destes comandos:

  # Build completo:
  make all

  # Ou passo a passo:
  bash scripts/build_kernel.sh

  # Ou teste rápido do shell:
  /workspaces/HubbleOS/tools/hbsh/hbsh

═══════════════════════════════════════════════════════════════════════════
EOF

echo ""
echo "Pressione Enter para fechar esta mensagem..."
read -r
