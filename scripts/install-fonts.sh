#!/bin/bash

################################################################################
# Script Auxiliar: Instalar Solo Fuentes
# Descripción: Instala las fuentes necesarias para BSPWM
################################################################################

set -e

readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

print_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }

echo -e "\n${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} Instalación de Fuentes"
echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"

print_info "Instalando fuentes desde repositorios oficiales..."
sudo pacman -S --noconfirm noto-fonts noto-fonts-emoji ttf-font-awesome
print_success "Fuentes oficiales instaladas"

# Verificar si yay está disponible
if command -v yay &>/dev/null; then
    print_info "Instalando fuentes desde AUR..."
    yay -S --noconfirm ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
    print_success "Fuentes de AUR instaladas"
else
    echo "⚠  yay no está disponible. Algunas fuentes Nerd no serán instaladas."
    echo "   Ejecuta: bash scripts/setup-aur.sh"
fi

print_info "Reconstruyendo cache de fuentes..."
fc-cache -fv
print_success "Cache de fuentes reconstruido"

echo -e "\n${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ✓ Fuentes instaladas exitosamente"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}\n"

echo "Fuentes disponibles:"
fc-list | grep -E "JetBrains|Noto|FontAwesome" | head -10
