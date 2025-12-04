# Makefile principal para HubbleOS

.PHONY: all build-hbsh build-kernel create-initramfs build-iso clean help

help:
	@echo "HubbleOS - Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make build-hbsh       - Compila o shell hbsh"
	@echo "  make build-kernel     - Compila o kernel Linux (demorado!)"
	@echo "  make create-initramfs - Cria initramfs com hbsh"
	@echo "  make build-iso        - Gera ISO bootável"
	@echo "  make all              - Compila tudo"
	@echo "  make clean            - Remove arquivos compilados"

build-hbsh:
	@echo "[*] Compilando hbsh..."
	cd tools/hbsh && make

build-kernel:
	@echo "[*] Compilando kernel (isto levará tempo)..."
	bash scripts/build_kernel.sh

create-initramfs: build-hbsh
	@echo "[*] Criando initramfs..."
	bash scripts/create_initramfs.sh

build-iso: create-initramfs
	@echo "[*] Gerando ISO..."
	bash scripts/build_iso.sh

all: build-hbsh build-kernel create-initramfs build-iso
	@echo "[✓] Build completo! ISO disponível em: build/hubbleos.iso"

clean:
	@echo "[*] Limpando build..."
	cd tools/hbsh && make clean
	rm -rf build/
	@echo "[✓] Limpo"
