#!/bin/bash

################################################################################
# Script de Desinstalación y Limpieza de BSPWM
# Descripción: Elimina archivos de configuración y paquetes de BSPWM
################################################################################

set -e

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} Desinstalación de BSPWM"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}\n"

print_warning "Esto eliminará todos los archivos de configuración de BSPWM."
read -p "¿Estás seguro? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    print_info "Operación cancelada."
    exit 0
fi

print_info "Eliminando archivos de configuración..."
rm -rf ~/.config/bspwm
rm -rf ~/.config/sxhkd
rm -rf ~/.config/polybar
rm -rf ~/.config/rofi
rm -rf ~/.config/kitty
rm -rf ~/.config/picom
rm -rf ~/.config/dunst
rm -f ~/.xinitrc

print_success "Archivos de configuración eliminados"

echo ""
read -p "¿Deseas desinstalar los paquetes también? (s/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    print_info "Desinstalando paquetes..."
    sudo pacman -R --noconfirm bspwm sxhkd picom dunst polybar rofi kitty thunar feh lxappearance arc-gtk-theme papirus-icon-theme 2>/dev/null || print_warning "Algunos paquetes no pudieron ser desinstalados"
    print_success "Paquetes desinstalados"
fi

echo -e "\n${GREEN}Desinstalación completada.${NC}\n"
