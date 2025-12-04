# HubbleOS - Guia Completo de Build

## Status Atual

✓ Estrutura de pastas criada
✓ Shell `hbsh` compilado 
✓ Gerenciador de pacotes `hbk` pronto
✓ Scripts de build preparados
✓ Kernel Linux presente (~7.6GB)

## Estrutura do Projeto

```
HubbleOS/
├── linux/                 # Kernel Linux (fornecido)
├── tools/
│   ├── hbsh/             # Shell personalizado (COMPILADO)
│   │   ├── hbsh          # Executável
│   │   ├── hbsh.c        # Código-fonte
│   │   └── Makefile
│   └── hbk.py            # Gerenciador de pacotes (Python)
├── scripts/
│   ├── build_kernel.sh   # Compila o kernel
│   ├── create_initramfs.sh  # Cria initramfs com hbsh
│   └── build_iso.sh      # Gera ISO bootável
├── build/                # Diretório de saída
├── packages/             # Pacotes para distribuição
├── Makefile              # Build system
└── README.md
```

## Passo a Passo para Build Completo

### Fase 1: Compilar o Kernel (30-60 minutos)

```bash
cd /workspaces/HubbleOS
bash scripts/build_kernel.sh
```

Isto irá:
1. Usar a configuração default para x86_64
2. Compilar o kernel (leva tempo)
3. Gerar saídas em `build/kernel/`

**Saídas esperadas:**
- `build/kernel/vmlinuz` - Kernel compilado
- `build/kernel/System.map` - Mapa de símbolos
- `build/kernel/kernel.config` - Configuração usada

### Fase 2: Criar Initramfs

```bash
bash scripts/create_initramfs.sh
```

Isto irá:
1. Compilar `hbsh` (já feito)
2. Copiar `hbsh` como `/bin/sh`
3. Copiar ferramentas do sistema (ls, cat, echo, etc)
4. Criar init script
5. Empacotar como cpio.gz

**Saída esperada:**
- `build/initramfs.cpio.gz` (~50-100MB)

### Fase 3: Gerar ISO Bootável

```bash
bash scripts/build_iso.sh
```

Isto irá:
1. Criar estrutura de diretórios ISO
2. Copiar kernel e initramfs
3. Configurar GRUB
4. Gerar ISO com xorriso ou grub-mkrescue

**Saída esperada:**
- `build/hubbleos.iso` (~500MB-1GB)

## Build Rápido (Uma Linha)

```bash
cd /workspaces/HubbleOS && make all
```

## Testar a ISO

```bash
# Com QEMU:
qemu-system-x86_64 -cdrom build/hubbleos.iso -m 512
```

## Componentes do HubbleOS

### 1. Kernel Linux
- Versão completa do kernel fornecida
- Compilado com suporte a ELF, initramfs, etc
- Pronto para customização

### 2. Shell (hbsh)
Localização: `tools/hbsh/hbsh`

Comandos disponíveis:
- `cd <dir>` - Trocar de diretório
- `pwd` - Mostrar diretório atual
- `help` - Mostrar comandos
- `exit` - Sair do shell
- Qualquer comando do sistema (ls, cat, etc)

```bash
# Testar interativamente:
/workspaces/HubbleOS/tools/hbsh/hbsh
```

### 3. Gerenciador de Pacotes (hbk)
Localização: `tools/hbk.py`

Uso:
```bash
python3 /workspaces/HubbleOS/tools/hbk.py init          # Inicializar
python3 /workspaces/HubbleOS/tools/hbk.py install pkg   # Instalar
python3 /workspaces/HubbleOS/tools/hbk.py list          # Listar
python3 /workspaces/HubbleOS/tools/hbk.py remove pkg    # Remover
```

Suporte a:
- Pacotes locais `.tar.gz`
- Nix (se instalado no sistema)

## Adicionar Ferramentas (git, gcc, curl, vim, Nix)

### Opção A: Via BusyBox (Recomendado para Espaço Limitado)

BusyBox fornece versões compactas de muitos comandos Unix:

```bash
# BusyBox está sendo copiado automaticamente no initramfs
# Fornece: sh, ls, cat, echo, mkdir, mount, kill, etc
```

### Opção B: Incluir Binários Compilados

1. Compilar ferramentas desejadas (git, gcc, curl, vim)
2. Copiar binários + dependências para `build/initramfs`
3. Recriar initramfs

Exemplo:
```bash
# Encontrar binário
which curl
# /usr/bin/curl

# Copiar para initramfs
cp /usr/bin/curl build/initramfs/usr/bin/
```

### Opção C: Usar Nix (Gerenciador de Pacotes Declarativo)

O gerenciador `hbk` já tem suporte básico a Nix. Para usar:

```bash
# Instalar Nix no host primeiro
curl -L https://nixos.org/nix/install | sh

# Então usar hbk para instalar pacotes
python3 /workspaces/HubbleOS/tools/hbk.py install git
python3 /workspaces/HubbleOS/tools/hbk.py install gcc
```

## Próximos Passos

1. **Compilar o kernel** (prioridade alta):
   ```bash
   bash /workspaces/HubbleOS/scripts/build_kernel.sh
   ```

2. **Criar initramfs**:
   ```bash
   bash /workspaces/HubbleOS/scripts/create_initramfs.sh
   ```

3. **Gerar ISO**:
   ```bash
   bash /workspaces/HubbleOS/scripts/build_iso.sh
   ```

4. **Testar com QEMU** (opcional):
   ```bash
   qemu-system-x86_64 -cdrom build/hubbleos.iso -m 512
   ```

## Troubleshooting

**Erro: "grub-mkrescue não encontrado"**
```bash
# Instalar grub e xorriso:
apt-get install grub-pc xorriso
```

**Erro: "Espaço em disco insuficiente"**
- Compilar kernel requer 15-20GB
- Se o espaço for insuficiente, usar configuração minimal:
  ```bash
  cd linux && make tinyconfig
  ```

**Shell hbsh não funciona**
- Verificar compilação: `ls -la tools/hbsh/hbsh`
- Recompilar: `cd tools/hbsh && make clean && make`

## Arquivos Importantes

- **Makefile** - Sistema de build
- **scripts/build_kernel.sh** - Compilação do kernel
- **scripts/create_initramfs.sh** - Criação de initramfs
- **scripts/build_iso.sh** - Geração de ISO
- **tools/hbsh/hbsh.c** - Código-fonte do shell
- **tools/hbk.py** - Código do gerenciador de pacotes

## Customização Avançada

### Adicionar Drivers Customizados
Editar `.config` do kernel antes de compilar:
```bash
cd linux
make menuconfig  # Interface interativa
```

### Trocar Shell Padrão
Editar `scripts/create_initramfs.sh` para usar shell diferente em `/init`

### Incluir Programas Customizados
Adicionar binários a `build/initramfs/bin/` antes de criar cpio
