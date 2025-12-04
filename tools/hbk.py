#!/usr/bin/env python3
"""
HubbleOS Package Manager (hbk)
Gerenciador de pacotes simples com suporte a tar.gz e integração com Nix
"""

import os
import sys
import json
import tarfile
import shutil
import subprocess
from pathlib import Path

HUBBLE_HOME = "/opt/hubble"
PACKAGES_DB = os.path.join(HUBBLE_HOME, "packages.json")
NIX_ENABLED = False

def ensure_dirs():
    """Cria diretórios necessários"""
    os.makedirs(HUBBLE_HOME, exist_ok=True)
    os.makedirs(os.path.join(HUBBLE_HOME, "packages"), exist_ok=True)

def load_packages_db():
    """Carrega banco de dados de pacotes"""
    if os.path.exists(PACKAGES_DB):
        with open(PACKAGES_DB, 'r') as f:
            return json.load(f)
    return {}

def save_packages_db(db):
    """Salva banco de dados de pacotes"""
    with open(PACKAGES_DB, 'w') as f:
        json.dump(db, f, indent=2)

def init():
    """Inicializa o gerenciador de pacotes"""
    ensure_dirs()
    
    if not os.path.exists(PACKAGES_DB):
        db = {
            "version": "1.0",
            "packages": {},
            "nix_enabled": False
        }
        save_packages_db(db)
        print(f"[hbk] Inicializado em {HUBBLE_HOME}")
    else:
        print(f"[hbk] Já inicializado em {HUBBLE_HOME}")

def install(package_path):
    """Instala um pacote .tar.gz"""
    ensure_dirs()
    
    if not os.path.exists(package_path):
        print(f"[hbk] Erro: arquivo não encontrado: {package_path}")
        return False
    
    try:
        # Extrai nome do pacote
        package_name = os.path.basename(package_path).replace('.tar.gz', '').replace('.tar', '')
        
        # Extrai para diretório temporário
        extract_dir = os.path.join(HUBBLE_HOME, "packages", package_name)
        os.makedirs(extract_dir, exist_ok=True)
        
        with tarfile.open(package_path, 'r:*') as tar:
            tar.extractall(path=extract_dir)
        
        # Atualiza banco de dados
        db = load_packages_db()
        db["packages"][package_name] = {
            "path": extract_dir,
            "installed": True
        }
        save_packages_db(db)
        
        print(f"[hbk] Pacote '{package_name}' instalado com sucesso")
        return True
        
    except Exception as e:
        print(f"[hbk] Erro ao instalar pacote: {e}")
        return False

def install_nix(package_name):
    """Instala pacote usando Nix"""
    global NIX_ENABLED
    
    try:
        result = subprocess.run(['nix-env', '-i', package_name], 
                              capture_output=True, text=True, check=True)
        print(f"[hbk] Pacote '{package_name}' instalado via Nix")
        NIX_ENABLED = True
        return True
    except subprocess.CalledProcessError as e:
        print(f"[hbk] Erro ao instalar com Nix: {e.stderr}")
        return False
    except FileNotFoundError:
        print("[hbk] Nix não está instalado")
        return False

def list_packages():
    """Lista pacotes instalados"""
    db = load_packages_db()
    
    if not db.get("packages"):
        print("[hbk] Nenhum pacote instalado")
        return
    
    print("[hbk] Pacotes instalados:")
    for name in db["packages"].keys():
        print(f"  - {name}")

def remove(package_name):
    """Remove um pacote"""
    db = load_packages_db()
    
    if package_name not in db.get("packages", {}):
        print(f"[hbk] Erro: pacote '{package_name}' não encontrado")
        return False
    
    try:
        pkg_path = db["packages"][package_name]["path"]
        shutil.rmtree(pkg_path)
        del db["packages"][package_name]
        save_packages_db(db)
        print(f"[hbk] Pacote '{package_name}' removido")
        return True
    except Exception as e:
        print(f"[hbk] Erro ao remover pacote: {e}")
        return False

def main():
    if len(sys.argv) < 2:
        print("Uso: hbk <comando> [argumentos]")
        print("Comandos:")
        print("  init <dir>       - Inicializa gerenciador em <dir>")
        print("  install <pkg>    - Instala pacote .tar.gz ou via Nix")
        print("  list             - Lista pacotes instalados")
        print("  remove <pkg>     - Remove um pacote")
        print("  help             - Mostra esta mensagem")
        sys.exit(1)
    
    cmd = sys.argv[1]
    
    if cmd == "init":
        init()
    elif cmd == "install":
        if len(sys.argv) < 3:
            print("[hbk] Uso: hbk install <pacote>")
            sys.exit(1)
        
        package = sys.argv[2]
        
        # Tenta instalar como arquivo local primeiro
        if os.path.exists(package):
            install(package)
        else:
            # Tenta via Nix
            install_nix(package)
    
    elif cmd == "list":
        list_packages()
    elif cmd == "remove":
        if len(sys.argv) < 3:
            print("[hbk] Uso: hbk remove <pacote>")
            sys.exit(1)
        remove(sys.argv[2])
    elif cmd == "help":
        print("HubbleOS Package Manager (hbk)")
        print("Gerenciador de pacotes simples com suporte a Nix")
    else:
        print(f"[hbk] Comando desconhecido: {cmd}")
        sys.exit(1)

if __name__ == "__main__":
    main()
