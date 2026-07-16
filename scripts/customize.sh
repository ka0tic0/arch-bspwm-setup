#!/bin/bash

################################################################################
# Script Auxiliar: Asistente Interactivo de Personalización
# Descripción: Menú interactivo para personalizar BSPWM fácilmente
################################################################################

readonly GREEN='\033[0;32m'
readonly CYAN='\033[0;36m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $1"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}\n"
}

print_menu() {
    echo -e "${CYAN}$1${NC}"
}

show_main_menu() {
    print_header "Asistente de Personalización BSPWM"
    
    echo "1) Cambiar tema de colores"
    echo "2) Configurar atajos de teclado"
    echo "3) Personalizar polybar"
    echo "4) Personalizar kitty"
    echo "5) Cambiar wallpaper"
    echo "6) Ver configuración actual"
    echo "0) Salir"
    echo ""
    read -p "Selecciona una opción: " opcion
}

change_theme() {
    print_header "Cambiar Tema"
    
    echo "Temas disponibles:"
    echo "1) Gruvbox (predeterminado)"
    echo "2) Dracula"
    echo "3) OneDark"
    echo "4) Nord"
    echo "0) Atrás"
    echo ""
    read -p "Selecciona un tema: " tema
    
    case $tema in
        1) bash themes/gruvbox-theme.sh ;;
        2) bash themes/dracula-theme.sh ;;
        3) bash themes/onedark-theme.sh ;;
        4) bash themes/nord-theme.sh ;;
        0) return ;;
        *) echo "Opción inválida" ;;
    esac
}

configure_shortcuts() {
    print_header "Configurar Atajos de Teclado"
    
    SXHKDRC="$HOME/.config/sxhkd/sxhkdrc"
    
    if [[ ! -f "$SXHKDRC" ]]; then
        echo "⚠  Archivo sxhkdrc no encontrado"
        return
    fi
    
    echo "1) Ver atajos actuales"
    echo "2) Editar atajos (nano)"
    echo "3) Editar atajos (vi)"
    echo "0) Atrás"
    echo ""
    read -p "Selecciona una opción: " opt
    
    case $opt in
        1) cat "$SXHKDRC" | head -30 ;;
        2) nano "$SXHKDRC" ;;
        3) vi "$SXHKDRC" ;;
        0) return ;;
    esac
}

personalize_polybar() {
    print_header "Personalizar Polybar"
    
    POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"
    
    if [[ ! -f "$POLYBAR_CONFIG" ]]; then
        echo "⚠  Archivo de Polybar no encontrado"
        return
    fi
    
    echo "1) Ver configuración actual"
    echo "2) Editar configuración"
    echo "3) Cambiar altura"
    echo "0) Atrás"
    echo ""
    read -p "Selecciona una opción: " opt
    
    case $opt in
        1) grep -E "height|width|font" "$POLYBAR_CONFIG" ;;
        2) nano "$POLYBAR_CONFIG" ;;
        3) 
            read -p "Nueva altura (p.ej. 35): " altura
            sed -i "s/height = .*/height = $altura/" "$POLYBAR_CONFIG"
            echo "Altura cambiada a $altura. Reinicia BSPWM para aplicar cambios."
            ;;
        0) return ;;
    esac
}

personalize_kitty() {
    print_header "Personalizar Kitty"
    
    KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"
    
    if [[ ! -f "$KITTY_CONFIG" ]]; then
        echo "⚠  Archivo de Kitty no encontrado"
        return
    fi
    
    echo "1) Ver configuración actual"
    echo "2) Editar configuración"
    echo "3) Cambiar tamaño de fuente"
    echo "4) Cambiar opacidad"
    echo "0) Atrás"
    echo ""
    read -p "Selecciona una opción: " opt
    
    case $opt in
        1) grep -E "font_size|background_opacity" "$KITTY_CONFIG" ;;
        2) nano "$KITTY_CONFIG" ;;
        3) 
            read -p "Nuevo tamaño de fuente (p.ej. 12): " size
            sed -i "s/font_size.*/font_size        $size/" "$KITTY_CONFIG"
            echo "Tamaño cambiado a $size. Reinicia Kitty para aplicar cambios."
            ;;
        4) 
            read -p "Opacidad (0.0-1.0, p.ej. 0.9): " opacity
            sed -i "s/background_opacity.*/background_opacity    $opacity/" "$KITTY_CONFIG"
            echo "Opacidad cambiada a $opacity. Reinicia Kitty para aplicar cambios."
            ;;
        0) return ;;
    esac
}

change_wallpaper() {
    print_header "Cambiar Wallpaper"
    
    WALLPAPER_DIR="$HOME/.config/bspwm"
    WALLPAPER_FILE="$WALLPAPER_DIR/wallpaper.jpg"
    
    echo "1) Cambiar wallpaper desde archivo"
    echo "2) Ver wallpaper actual"
    echo "3) Usar wallpaper aleatorio"
    echo "0) Atrás"
    echo ""
    read -p "Selecciona una opción: " opt
    
    case $opt in
        1)
            read -p "Ruta del archivo de imagen: " ruta
            if [[ -f "$ruta" ]]; then
                feh --bg-scale "$ruta"
                cp "$ruta" "$WALLPAPER_FILE"
                echo "Wallpaper cambiado exitosamente"
            else
                echo "⚠  Archivo no encontrado"
            fi
            ;;
        2)
            if [[ -f "$WALLPAPER_FILE" ]]; then
                echo "Wallpaper actual: $WALLPAPER_FILE"
            else
                echo "No hay wallpaper configurado"
            fi
            ;;
        3)
            read -p "Ruta del directorio con imágenes: " dir
            if [[ -d "$dir" ]]; then
                feh --bg-scale --randomize "$dir"/*.{jpg,png} 2>/dev/null
                echo "Wallpaper aleatorio aplicado"
            else
                echo "⚠  Directorio no encontrado"
            fi
            ;;
        0) return ;;
    esac
}

show_config() {
    print_header "Configuración Actual"
    
    echo "BSPWM:"
    bspc config border_width
    bspc config window_gap
    echo ""
    
    echo "Kitty:"
    grep "font_size\|background_opacity" ~/.config/kitty/kitty.conf 2>/dev/null || echo "No configurado"
    echo ""
    
    echo "Polybar:"
    grep "height\|width" ~/.config/polybar/config.ini 2>/dev/null | head -2 || echo "No configurado"
}

# Menú principal
while true; do
    show_main_menu
    
    case $opcion in
        1) change_theme ;;
        2) configure_shortcuts ;;
        3) personalize_polybar ;;
        4) personalize_kitty ;;
        5) change_wallpaper ;;
        6) show_config ;;
        0) echo "¡Hasta luego!"; exit 0 ;;
        *) echo "Opción inválida" ;;
    esac
    
    read -p "\nPresiona Enter para continuar..."
done
