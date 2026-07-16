#!/bin/bash

################################################################################
# Script de Tema: Dracula
# Descripción: Aplica la paleta de colores Dracula a BSPWM y aplicaciones
################################################################################

set -e

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

print_info() { echo -e "${CYAN}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }

echo -e "\n${CYAN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC} Aplicando Tema: DRACULA"
echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"

# Colores del tema Dracula
BG="#282a36"
FG="#f8f8f2"
PRIMARY="#50fa7b"
SECONDARY="#ff79c6"
ACCENT="#8be9fd"

# 1. Actualizar BSPWM
print_info "Actualizando colores de BSPWM..."
bspc config normal_border_color "#44475a"
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
else
    echo "Advertencia: Archivo de Polybar no encontrado"
fi

# 3. Actualizar Kitty
print_info "Actualizando Kitty..."
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"

if [[ -f "$KITTY_CONFIG" ]]; then
    sed -i "s/foreground.*/foreground            $FG/" "$KITTY_CONFIG"
    sed -i "s/background.*/background            $BG/" "$KITTY_CONFIG"
    
    # Actualizar colores específicos de Dracula
    sed -i "s/color1.*/color1  #ff5555/" "$KITTY_CONFIG"
    sed -i "s/color2.*/color2  $PRIMARY/" "$KITTY_CONFIG"
    sed -i "s/color3.*/color3  #f1fa8c/" "$KITTY_CONFIG"
    sed -i "s/color4.*/color4  $ACCENT/" "$KITTY_CONFIG"
    sed -i "s/color5.*/color5  $SECONDARY/" "$KITTY_CONFIG"
    sed -i "s/color6.*/color6  #8be9fd/" "$KITTY_CONFIG"
    
    print_success "Kitty actualizado"
else
    echo "Advertencia: Archivo de Kitty no encontrado"
fi

# 4. Actualizar Dunst
print_info "Actualizando Dunst..."
DUNST_CONFIG="$HOME/.config/dunst/dunstrc"

if [[ -f "$DUNST_CONFIG" ]]; then
    # Actualizar urgencia normal
    sed -i '/\[urgency_normal\]/,/^\[/s/background = .*/background = "'$BG'"/' "$DUNST_CONFIG"
    sed -i '/\[urgency_normal\]/,/^\[/s/foreground = .*/foreground = "'$FG'"/' "$DUNST_CONFIG"
    
    # Actualizar urgencia crítica
    sed -i '/\[urgency_critical\]/,/^\[/s/background = .*/background = "#282a36"/' "$DUNST_CONFIG"
    sed -i '/\[urgency_critical\]/,/^\[/s/foreground = .*/foreground = "#ff5555"/' "$DUNST_CONFIG"
    sed -i '/\[urgency_critical\]/,/^\[/s/frame_color = .*/frame_color = "#ff5555"/' "$DUNST_CONFIG"
    
    print_success "Dunst actualizado"
else
    echo "Advertencia: Archivo de Dunst no encontrado"
fi

# 5. Reiniciar servicios
print_info "Reiniciando servicios..."
pkill polybar 2>/dev/null || true
sleep 0.5
~/.config/polybar/launch.sh &
print_success "Servicios reiniciados"

echo -e "\n${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ✓ Tema Dracula aplicado exitosamente"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}\n"
