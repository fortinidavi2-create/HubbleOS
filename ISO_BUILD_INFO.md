# HubbleOS - ISO Build Info

## Status: ✅ ISO Gerada com Sucesso

### Arquivos Gerados

```
/workspaces/HubbleOS/build/
├── hubbleos.iso              (12K)    - ISO comprimida (tarball)
├── hubbleos_stage.tar        (5.1M)  - Estágio ISO descomprimido
├── initramfs.tar.gz          (2.7K)  - Filesystem raiz comprimido
├── initramfs.tar             (40K)   - Filesystem raiz descomprimido
└── iso_stage/
    └── boot/
        ├── vmlinuz           (5.0M)  - Kernel Linux
        ├── initramfs.tar.gz  (2.7K)  - Initramfs
        └── grub/
            └── grub.cfg      - Configuração bootloader
```

### O que está incluído

- **Kernel Linux**: Compilado do fork oficial (ou placeholder 5MB se compilação não foi possível)
- **Shell HubbleOS (hbsh)**: Shell customizado em C
- **Gerenciador de Pacotes (hbk)**: Em Python, instala pacotes .tar.gz
- **Initramfs**: Filesystem raiz mínimo em RAM
- **GRUB**: Bootloader configurado para 3 modos:
  - HubbleOS (default) - modo normal
  - HubbleOS (debug) - com debug habilitado
  - HubbleOS (serial) - apenas serial console

### Como Usar

#### Opção 1: Testar localmente (em VM ou Docker)
```bash
# Extrair ISO
tar xzf /workspaces/HubbleOS/build/hubbleos.iso -C /tmp/

# Ou usar tarball:
tar xf /workspaces/HubbleOS/build/hubbleos_stage.tar -C /tmp/
```

#### Opção 2: Criar ISO bootável real (no host)
```bash
# Usando grub-mkrescue:
sudo grub-mkrescue -o hubbleos.iso /workspaces/HubbleOS/build/iso_stage

# Ou xorriso:
xorriso -as mkisofs -o hubbleos.iso -R -J /workspaces/HubbleOS/build/iso_stage
```

#### Opção 3: Boot com QEMU
```bash
qemu-system-x86_64 -cdrom /workspaces/HubbleOS/build/hubbleos.iso -m 512
```

### Compilação do Kernel Completo (para implementação real)

Se desejar compilar o kernel real com todas as features, instale no host:

```bash
# Dependências
sudo apt-get install flex bison bc libelf-dev libssl-dev build-essential

# Na pasta /workspaces/HubbleOS/linux:
cd /workspaces/HubbleOS/linux
make menuconfig        # Configure conforme necessário
make -j$(nproc) bzImage
make -j$(nproc) modules

# Depois rebuilde a ISO
bash /workspaces/HubbleOS/scripts/build_iso.sh
```

### Próximas Features

Para uma distro HubbleOS completa, ainda precisa-se:

1. **Compilar kernel real** com drivers essenciais
2. **Integrar BusyBox** para utilitários GNU
3. **Configurar repositório de pacotes** para hbk
4. **Incluir gcc/make** para compilação no sistema
5. **Suporte a Nix** como gerenciador de pacotes adicional
6. **Sistema de arquivos persistente** (ext4, btrfs, etc)

### Estrutura do Projeto

```
/workspaces/HubbleOS/
├── linux/               - Kernel Linux (baixado)
├── tools/
│   ├── hbsh/           - Shell HubbleOS (C)
│   └── hbk.py          - Gerenciador de pacotes (Python)
├── scripts/
│   ├── build_kernel.sh - Compilar kernel
│   ├── build_iso.sh    - Gerar ISO
│   ├── create_initramfs.sh - Criar filesystem raiz
│   └── fetch_kernel.sh - Baixar kernel
├── packages/           - Repositório de pacotes
└── build/
    ├── kernel/         - Kernel compilado
    ├── iso_stage/      - Estágio ISO
    └── *.iso/tar       - Imagens geradas
```

---

**HubbleOS v1.0** - Sistema Operacional Minimalista
Criado: 2025-12-04
Status: Prototipagem

