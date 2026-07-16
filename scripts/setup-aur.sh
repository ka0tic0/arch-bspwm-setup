#!/bin/bash

################################################################################
# Script Auxiliar: Configurar AUR Helper (yay)
# Descripción: Instala y configura yay si no está presente
################################################################################

set -e

readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

print_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }

echo -e "\n${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} Configuración de AUR Helper"
echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"

# Verificar si yay está instalado
if command -v yay &>/dev/null; then
    print_success "yay ya está instalado"
    yay --version
    exit 0
fi

print_info "Instalando dependencias..."
sudo pacman -S --noconfirm base-devel git

print_info "Clonando repositorio de yay..."
cd /tmp || exit 1
[[ -d yay ]] && rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay || exit 1

print_info "Compilando yay..."
makepkg -si --noconfirm

cd ~ || exit 1

print_success "yay instalado exitosamente"
yay --version

echo -e "\n${CYAN}Próximos pasos:${NC}"
echo "• yay -Syu: Actualizar todos los paquetes"
echo "• yay -S <paquete>: Instalar paquete de AUR"
echo "• yay -R <paquete>: Desinstalar paquete"
