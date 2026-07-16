#!/bin/bash

################################################################################
# Script de Tema: OneDark
# Descripción: Aplica la paleta de colores OneDark (VS Code inspired)
################################################################################

set -e

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

print_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }

echo -e "\n${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} Aplicando Tema: ONEDARK"
echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"

# Colores del tema OneDark
BG="#282c34"
FG="#abb2bf"
PRIMARY="#98c379"
SECONDARY="#e06c75"
ACCENT="#61afef"

# 1. Actualizar BSPWM
print_info "Actualizando colores de BSPWM..."
bspc config normal_border_color "#3e4451"
bspc config active_border_color "$SECONDARY"
bspc config focused_border_color "$PRIMARY"
print_success "Colores de BSPWM actualizados"

# 2. Actualizar Polybar
print_info "Actualizando Polybar..."
POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"

if [[ -f "$POLYBAR_CONFIG" ]]; then
    sed -i "s/background = .*/background = $BG/" "$POLYBAR_CONFIG"
    sed -i "s/foreground = .*/foreground = $FG/" "$POLYBAR_CONFIG"
    sed -i "s/primary = .*/primary = $PRIMARY/" "$POLYBAR_CONFIG"
    sed -i "s/secondary = .*/secondary = $SECONDARY/" "$POLYBAR_CONFIG"
    print_success "Polybar actualizado"
fi

# 3. Actualizar Kitty
print_info "Actualizando Kitty..."
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"

if [[ -f "$KITTY_CONFIG" ]]; then
    sed -i "s/foreground.*/foreground            $FG/" "$KITTY_CONFIG"
    sed -i "s/background.*/background            $BG/" "$KITTY_CONFIG"
    
    # Colores específicos de OneDark
    sed -i "s/color1.*/color1  #e06c75/" "$KITTY_CONFIG"
    sed -i "s/color2.*/color2  $PRIMARY/" "$KITTY_CONFIG"
    sed -i "s/color3.*/color3  #d19a66/" "$KITTY_CONFIG"
    sed -i "s/color4.*/color4  $ACCENT/" "$KITTY_CONFIG"
    sed -i "s/color5.*/color5  #c678dd/" "$KITTY_CONFIG"
    sed -i "s/color6.*/color6  #56b6c2/" "$KITTY_CONFIG"
    
    print_success "Kitty actualizado"
fi

# 4. Actualizar Dunst
print_info "Actualizando Dunst..."
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"

if [[ -f "$DUNST_CONFIG" ]]; then
    sed -i '/\[urgency_normal\]/,/^\[/s/background = .*/background = "'$BG'"/' "$DUNST_CONFIG"
    sed -i '/\[urgency_normal\]/,/^\[/s/foreground = .*/foreground = "'$FG'"/' "$DUNST_CONFIG"
    sed -i '/\[urgency_critical\]/,/^\[/s/background = .*/background = "#282c34"/' "$DUNST_CONFIG"
    sed -i '/\[urgency_critical\]/,/^\[/s/foreground = .*/foreground = "#e06c75"/' "$DUNST_CONFIG"
    
    print_success "Dunst actualizado"
fi

# 5. Reiniciar servicios
print_info "Reiniciando servicios..."
pkill polybar 2>/dev/null || true
sleep 0.5
~/.config/polybar/launch.sh &
print_success "Servicios reiniciados"

echo -e "\n${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ✓ Tema OneDark aplicado exitosamente"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}\n"
