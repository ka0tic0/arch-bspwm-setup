#!/bin/bash

################################################################################
# Script de Instalación y Configuración de BSPWM en Arch Linux
# Autor: Entorno de Escritorio BSPWM Automatizado
# Descripción: Automatiza la instalación de paquetes y configuración inicial
#              para un ambiente de escritorio completo basado en BSPWM
################################################################################

# Configuración de opciones del script para manejo robusto de errores
set -e  # Detener si hay cualquier error no capturado

# Colores para salida en terminal (mejor legibilidad)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'  # No Color

################################################################################
# FUNCIONES AUXILIARES
################################################################################

# Función para imprimir mensajes de información con color
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Función para imprimir mensajes de éxito
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

# Función para imprimir mensajes de advertencia
print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

# Función para imprimir mensajes de error
print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Función para imprimir títulos de secciones
print_header() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC} $1"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

# Función para verificar si el script se ejecuta con permisos de usuario regular
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "Este script NO debe ejecutarse como root."
        print_info "Ejecuta el script como usuario regular sin 'sudo'."
        exit 1
    fi
}

# Función para verificar si un paquete está instalado
is_installed() {
    pacman -Q "$1" &>/dev/null
}

# Función para instalar un paquete desde repositorios oficiales con pacman
install_official_package() {
    local package="$1"
    
    if is_installed "$package"; then
        print_warning "$package ya está instalado, omitiendo..."
    else
        print_info "Instalando $package desde repositorios oficiales..."
        sudo pacman -S --noconfirm "$package"
        print_success "$package instalado correctamente"
    fi
}

# Función para instalar un paquete desde AUR usando yay
install_aur_package() {
    local package="$1"
    
    if is_installed "$package"; then
        print_warning "$package ya está instalado, omitiendo..."
    else
        print_info "Instalando $package desde AUR usando yay..."
        yay -S --noconfirm "$package"
        print_success "$package instalado correctamente"
    fi
}

# Función para crear directorios si no existen
create_directory() {
    local dir="$1"
    
    if [[ -d "$dir" ]]; then
        print_warning "Directorio $dir ya existe"
    else
        print_info "Creando directorio: $dir"
        mkdir -p "$dir"
        print_success "Directorio creado: $dir"
    fi
}

################################################################################
# VERIFICACIONES PREVIAS
################################################################################

print_header "VERIFICACIONES PREVIAS"

# Verificar que no se ejecuta como root
check_not_root

# Verificar que estamos en Arch Linux
if ! [[ -f /etc/arch-release ]]; then
    print_error "Este script está diseñado para Arch Linux."
    print_info "Por favor, ejecuta este script en una instalación de Arch Linux."
    exit 1
fi
print_success "Sistema detectado como Arch Linux"

# Verificar disponibilidad de sudo
if ! sudo -n true 2>/dev/null; then
    print_warning "Este script requiere permisos de sudo."
    print_info "Se te pedirá ingresar tu contraseña para operaciones que lo requieran."
    sudo -v
fi
print_success "Permisos de sudo verificados"

# Verificar si yay está instalado (necesario para paquetes de AUR)
if ! command -v yay &> /dev/null; then
    print_warning "yay (helper de AUR) no está instalado."
    print_info "Procediendo a instalar yay..."
    
    # Instalación de dependencias necesarias para construir yay
    sudo pacman -S --noconfirm base-devel git
    
    # Clonar y construir yay desde AUR
    cd /tmp || exit 1
    if [[ -d yay ]]; then
        rm -rf yay
    fi
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit 1
    makepkg -si --noconfirm
    cd ~ || exit 1
    
    print_success "yay instalado correctamente"
fi

# Actualizar base de datos de pacman y yay
print_info "Actualizando base de datos de paquetes..."
sudo pacman -Sy
yay -Sy
print_success "Base de datos actualizada"

################################################################################
# INSTALACIÓN DE PAQUETES
################################################################################

print_header "INSTALACIÓN DE PAQUETES"

# Arrays que contienen todos los paquetes a instalar, organizados por categoría

# Paquetes de X11 y servidor gráfico
declare -a PACKAGES_XORG=(
    "xorg"
    "xorg-xinit"
)

# Gestor de ventanas y atajo de teclado
declare -a PACKAGES_WM=(
    "bspwm"
    "sxhkd"
)

# Compositor y notificaciones
declare -a PACKAGES_COMPOSITOR=(
    "picom"
    "dunst"
)

# Barra de estado y lanzador de aplicaciones
declare -a PACKAGES_BAR=(
    "polybar"
    "rofi"
)

# Terminal y gestor de archivos
declare -a PACKAGES_UTILS=(
    "kitty"
    "thunar"
)

# Utilidades de fondo de pantalla y apariencia
declare -a PACKAGES_APPEARANCE=(
    "feh"
    "lxappearance"
    "orchis-theme"
    "sudo pacman -S tela-circle-icon-theme-all"
)

# Red y audio
declare -a PACKAGES_AUDIO_NET=(
    "networkmanager"
    "network-manager-applet"
    "pipewire"
    "pipewire-alsa"
    "pipewire-pulse"
    "pipewire-jack"
    "wireplumber"
)

# Fuentes (algunas requieren AUR)
declare -a PACKAGES_FONTS_OFFICIAL=(
    "noto-fonts"
    "noto-fonts-emoji"
    "ttf-font-awesome"
)

declare -a PACKAGES_FONTS_AUR=(
    "ttf-jetbrains-mono-nerd"
    "ttf-nerd-fonts-symbols"
)

# Instalar paquetes de X11
print_info "Instalando paquetes de X11..."
for package in "${PACKAGES_XORG[@]}"; do
    install_official_package "$package"
done

# Instalar gestor de ventanas
print_info "Instalando gestor de ventanas (BSPWM) y manejo de atajos..."
for package in "${PACKAGES_WM[@]}"; do
    install_official_package "$package"
done

# Instalar compositor y notificaciones
print_info "Instalando compositor y sistema de notificaciones..."
for package in "${PACKAGES_COMPOSITOR[@]}"; do
    install_official_package "$package"
done

# Instalar barra y lanzador
print_info "Instalando barra de estado y lanzador..."
for package in "${PACKAGES_BAR[@]}"; do
    install_official_package "$package"
done

# Instalar utilidades
print_info "Instalando terminal y gestor de archivos..."
for package in "${PACKAGES_UTILS[@]}"; do
    install_official_package "$package"
done

# Instalar utilidades de apariencia
print_info "Instalando utilidades de fondo de pantalla y temas..."
for package in "${PACKAGES_APPEARANCE[@]}"; do
    install_official_package "$package"
done

# Instalar paquetes de red y audio
print_info "Instalando paquetes de red y audio..."
for package in "${PACKAGES_AUDIO_NET[@]}"; do
    install_official_package "$package"
done

# Instalar fuentes desde repositorios oficiales
print_info "Instalando fuentes desde repositorios oficiales..."
for package in "${PACKAGES_FONTS_OFFICIAL[@]}"; do
    install_official_package "$package"
done

# Instalar fuentes desde AUR
print_info "Instalando fuentes desde AUR..."
for package in "${PACKAGES_FONTS_AUR[@]}"; do
    install_aur_package "$package"
done

print_success "Todos los paquetes han sido instalados exitosamente"

################################################################################
# ESTRUCTURA DE DIRECTORIOS DE CONFIGURACIÓN
################################################################################

print_header "CREANDO ESTRUCTURA DE DIRECTORIOS"

# Variable que contiene la ruta al directorio de configuración del usuario
CONFIG_HOME="${HOME}/.config"

# Crear directorios principales para cada aplicación
print_info "Creando estructura de directorios en $CONFIG_HOME..."

declare -a CONFIG_DIRS=(
    "$CONFIG_HOME/bspwm"
    "$CONFIG_HOME/sxhkd"
    "$CONFIG_HOME/picom"
    "$CONFIG_HOME/polybar"
    "$CONFIG_HOME/rofi"
    "$CONFIG_HOME/kitty"
    "$CONFIG_HOME/thunar"
    "$CONFIG_HOME/dunst"
)

for dir in "${CONFIG_DIRS[@]}"; do
    create_directory "$dir"
done

print_success "Estructura de directorios creada"

################################################################################
# CONFIGURACIÓN DE BSPWM Y SXHKD
################################################################################

print_header "CONFIGURACIÓN DE BSPWM Y SXHKD"

# Copiar archivo de configuración de bspwm desde la instalación del paquete
BSPWM_DOC_DIR="/usr/share/doc/bspwm"
BSPWM_EXAMPLE_DIR="/usr/share/doc/bspwm/examples"

if [[ -f "$BSPWM_EXAMPLE_DIR/bspwmrc" ]]; then
    print_info "Copiando bspwmrc desde la documentación..."
    cp "$BSPWM_EXAMPLE_DIR/bspwmrc" "$CONFIG_HOME/bspwm/bspwmrc"
    print_success "bspwmrc copiado"
else
    print_warning "No se encontró bspwmrc en la documentación."
    print_info "Creando archivo bspwmrc básico..."
    
    cat > "$CONFIG_HOME/bspwm/bspwmrc" << 'EOF'
#!/bin/bash

# Configuración de BSPWM
# Este es un archivo de configuración básico para bspwm

# Establecer número de espacios de trabajo (desktops)
bspc monitor -d 1 2 3 4 5 

# Configuración de bordes y espaciado
bspc config border_width 2
bspc config window_gap 12

# Colores de bordes
bspc config normal_border_color "#3c3836"
bspc config active_border_color "#83a598"
bspc config focused_border_color "#b8bb26"

# Comportamiento de las ventanas
bspc config split_ratio 0.52
bspc config single_monocle false
bspc config click_to_focus button1
bspc config focus_follows_pointer false

# Reglas automáticas para ventanas específicas
bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off

EOF
fi

# Dar permisos de ejecución al archivo bspwmrc
print_info "Otorgando permisos de ejecución a bspwmrc..."
chmod +x "$CONFIG_HOME/bspwm/bspwmrc"
print_success "Permisos de ejecución otorgados"

# Copiar archivo de configuración de sxhkd
SXHKD_EXAMPLE_DIR="/usr/share/doc/sxhkd/examples"

if [[ -f "$SXHKD_EXAMPLE_DIR/sxhkdrc" ]]; then
    print_info "Copiando sxhkdrc desde la documentación..."
    cp "$SXHKD_EXAMPLE_DIR/sxhkdrc" "$CONFIG_HOME/sxhkd/sxhkdrc"
    print_success "sxhkdrc copiado"
else
    print_warning "No se encontró sxhkdrc en la documentación."
    print_info "Creando archivo sxhkdrc básico con atajos comunes..."
    
    cat > "$CONFIG_HOME/sxhkd/sxhkdrc" << 'EOF'
# Atajos de teclado para BSPWM

# Terminal
super + Return
    kitty

# Lanzador de programas
super + d
    rofi -show drun

# Cerrar ventana enfocada
super + w
    bspc node -c

# Alternar modo fullscreen
super + f
    bspc node -t ~fullscreen

# Alternar modo flotante
super + shift + f
    bspc node -t ~floating

# Cambiar enfoque entre ventanas (izquierda/derecha/arriba/abajo)
super + {h,j,k,l}
    bspc node -f {west,south,north,east}

# Cambiar enfoque entre espacios de trabajo
super + {1-5}
    bspc desktop -f '^{1-5}'

# Mover ventana a espacio de trabajo
super + shift + {1-5}
    bspc node -d '^{1-5}'

# Expandir ventana
super + ctrl + {h,j,k,l}
    bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# Contraer ventana
super + ctrl + shift + {h,j,k,l}
    bspc node -z {left 20 0,bottom 0 -20,top 0 20,right -20 0}

# Equilibrar espaciado
super + e
    bspc node @/ -B

# Reiniciar BSPWM
super + ctrl + r
    bspc wm -r

# Salir de BSPWM
super + ctrl + q
    bspc quit

EOF
fi

print_success "Configuración de BSPWM y SXHKD completada"

################################################################################
# CONFIGURACIÓN DEL AUTOSTART EN BSPWMRC
################################################################################

print_header "CONFIGURANDO AUTOSTART EN BSPWMRC"

# Leer el archivo bspwmrc actual
BSPWMRC_FILE="$CONFIG_HOME/bspwm/bspwmrc"

# Verificar si las líneas de autostart ya están presentes
if ! grep -q "sxhkd" "$BSPWMRC_FILE"; then
    print_info "Añadiendo comandos de autostart al final de bspwmrc..."
    
    cat >> "$BSPWMRC_FILE" << 'EOF'

# ============================================================================
# AUTOSTART - Iniciar aplicaciones al arrancar BSPWM
# ============================================================================

# Iniciar el daemon de atajos de teclado (SXHKD)
sxhkd -c ~/.config/sxhkd/sxhkdrc &

# Iniciar el compositor (picom)
picom --config ~/.config/picom/picom.conf &

# Iniciar el daemon de notificaciones (dunst)
dunst &

# Iniciar el applet de NetworkManager
nm-applet &

# Iniciar la barra de estado (Polybar)
if command -v polybar &>/dev/null; then
    ~/.config/polybar/launch.sh &
fi

# Establecer fondo de pantalla con feh
if command -v feh &>/dev/null; then
    feh --bg-scale ~/.config/bspwm/wallpaper.jpg 2>/dev/null || true
fi

EOF
    
    print_success "Comandos de autostart añadidos a bspwmrc"
else
    print_warning "Los comandos de autostart ya están presentes en bspwmrc"
fi

################################################################################
# CONFIGURACIÓN DE PICOM
################################################################################

print_header "CONFIGURACIÓN DE PICOM"

PICOM_CONFIG="$CONFIG_HOME/picom/picom.conf"

if [[ ! -f "$PICOM_CONFIG" ]]; then
    print_info "Creando configuración básica de picom..."
    
    cat > "$PICOM_CONFIG" << 'EOF'
# Configuración de Picom (Compositor X11)

backend = "glx";
vsync = true;
glx-use-copysubbuffer-mesa = true;

inactive-opacity = 0.95;
frame-opacity = 1.0;
inactive-opacity-override = false;

shadow = true;
shadow-radius = 7;
shadow-offset-x = -7;
shadow-offset-y = -7;
shadow-opacity = 0.5;

blur-background = false;
blur-background-frame = false;

transition-length = 300;
transition-pow-x = 0.1;
transition-pow-y = 0.1;

shadow-exclude = [
    "class_g = 'Polybar'",
    "class_g = 'Dunst'"
];

focus-exclude = [
    "class_g = 'Polybar'"
];

EOF
    
    print_success "Configuración de picom creada"
else
    print_warning "Archivo de configuración de picom ya existe"
fi

################################################################################
# CONFIGURACIÓN DE POLYBAR
################################################################################

print_header "CONFIGURACIÓN DE POLYBAR"

POLYBAR_CONFIG="$CONFIG_HOME/polybar/config.ini"
POLYBAR_LAUNCH="$CONFIG_HOME/polybar/launch.sh"

if [[ ! -f "$POLYBAR_CONFIG" ]]; then
    print_info "Creando configuración básica de polybar..."
    
    cat > "$POLYBAR_CONFIG" << 'EOF'
[colors]
background = #282828
foreground = #ebdbb2
primary = #98c379
secondary = #e06c75
alert = #ff6b6b

[bar/mybar]
width = 100%
height = 27
fixed-center = true
background = ${colors.background}
foreground = ${colors.foreground}
padding-left = 2
padding-right = 2
module-margin-left = 1
module-margin-right = 1

font-0 = "JetBrains Mono:pixelsize=10;1"
font-1 = "Noto Sans:pixelsize=10;1"
font-2 = "Nerd Font Symbols:pixelsize=12;2"

modules-left = arch bspwm
modules-center = date
modules-right = powermenu filesystem pulseaudio

tray-position = right
tray-padding = 2
tray-maxsize = 20

cursor-click = pointer
cursor-scroll = ns-resize


[module/arch]
type = custom/text
content = ""
content-font = 2
content-foreground = ${colors.primary}
content-padding = 1

[module/bspwm]
type = internal/bspwm
pin-workspaces = true
enable-click = true

ws-icon-0 = 1;
ws-icon-1 = 2;
ws-icon-2 = 3;
ws-icon-3 = 4;
ws-icon-4 = 5;󰺄


format = <label-state>
label-focused = %icon%
label-focused-background = ${colors.primary}
label-focused-foreground = ${colors.background}
label-focused-padding = 2

label-occupied = %icon%
label-occupied-background = ${colors.secondary}
label-occupied-foreground = ${colors.background}
label-occupied-padding = 2

label-empty = %icon%
label-empty-padding = 2

[module/date]
type = internal/date
interval = 60
date = "%d-%m-%Y"
time = "%H:%M"
label = %date% %time%

======================================
MODULOS DERECHOS
======================================
[module/powermenu]
type = custom/text
content = ""
content-font = 2
content-foreground = ${colors.alert}
# Cambiamos esta línea para que apunte a tu nuevo script
# click-left = ~/.local/bin/powermenu.sh

[module/filesystem]
type = internal/fs
mount-0 = /
interval = 30

# Bloque Amarillo
format-mounted = <label-mounted>
format-mounted-prefix = "󰋊 "
format-mounted-background = ${colors.yellow}
format-mounted-foreground = ${colors.module-text}
format-mounted-padding = 1

label-mounted = %percentage_used%%

format-unmounted = <label-unmounted>
format-unmounted-prefix = "󰋊 "
format-unmounted-background = ${colors.alert}
format-unmounted-foreground = ${colors.module-text}
format-unmounted-padding = 1
label-unmounted = %mountpoint% no montado

[module/pulseaudio]
type = internal/pulseaudio

# Bloque Verde
format-volume = <ramp-volume> <label-volume>
format-volume-background = ${colors.green}
format-volume-foreground = ${colors.module-text}
format-volume-padding = 1

label-volume = %percentage%%

ramp-volume-0 = 
ramp-volume-1 = 
ramp-volume-2 = 

label-muted = 󰖁 silenciado
label-muted-background = ${colors.empty}
label-muted-foreground = ${colors.module-text}
label-muted-padding = 1

EOF
    
    print_success "Configuración de polybar creada"
else
    print_warning "Archivo de configuración de polybar ya existe"
fi

if [[ ! -f "$POLYBAR_LAUNCH" ]]; then
    print_info "Creando script de lanzamiento de polybar..."
    
    cat > "$POLYBAR_LAUNCH" << 'EOF'
#!/bin/bash

killall polybar 2>/dev/null || true
sleep 0.5

MONITOR=$(xrandr --query | grep " connected primary" | cut -d" " -f1)

if [[ -z "$MONITOR" ]]; then
    MONITOR=$(xrandr --query | grep " connected" | head -n 1 | cut -d" " -f1)
fi

if [[ -n "$MONITOR" ]]; then
    MONITOR=$MONITOR polybar mybar &
else
    polybar mybar &
fi

wait

EOF
    
    chmod +x "$POLYBAR_LAUNCH"
    print_success "Script de lanzamiento de polybar creado"
fi

################################################################################
# CONFIGURACIÓN DE ROFI
################################################################################

print_header "CONFIGURACIÓN DE ROFI"

ROFI_CONFIG="$CONFIG_HOME/rofi/config.rasi"

if [[ ! -f "$ROFI_CONFIG" ]]; then
    print_info "Creando configuración básica de rofi..."
    
    cat > "$ROFI_CONFIG" << 'EOF'
/* Configuración de Rofi */

configuration {
    modi: "drun,run";
    display-drun: "Aplicaciones";
    display-run: "Ejecutar";
    font: "JetBrains Mono 10";
    lines: 15;
    columns: 1;
    hide-scrollbar: true;
    click-to-exit: true;
}

EOF
    
    print_success "Configuración de rofi creada"
fi

################################################################################
# CONFIGURACIÓN DE KITTY
################################################################################

print_header "CONFIGURACIÓN DE KITTY"

KITTY_CONFIG="$CONFIG_HOME/kitty/kitty.conf"

if [[ ! -f "$KITTY_CONFIG" ]]; then
    print_info "Creando configuración básica de kitty..."
    
    cat > "$KITTY_CONFIG" << 'EOF'
font_family      JetBrains Mono
font_size        11
font_features    +ss01
disable_ligatures never

foreground            #ebdbb2
background            #282828
background_opacity    0.95

color0  #282828
color1  #cc241d
color2  #98c379
color3  #d79921
color4  #458588
color5  #b16286
color6  #689d6a
color7  #a89984

cursor_shape        beam
cursor_blink_interval 0.5

remember_window_size  yes
initial_window_width  800
initial_window_height 600

enable_audio_bell    no
visual_bell_duration 0.1

tab_bar_edge         bottom
tab_bar_style        powerline

EOF
    
    print_success "Configuración de kitty creada"
fi

################################################################################
# CONFIGURACIÓN DE DUNST
################################################################################

print_header "CONFIGURACIÓN DE DUNST"

DUNST_CONFIG="$CONFIG_HOME/dunst/dunstrc"

if [[ ! -f "$DUNST_CONFIG" ]]; then
    print_info "Creando configuración básica de dunst..."
    
    cat > "$DUNST_CONFIG" << 'EOF'
[global]
    monitor = 0
    geometry = "350x50-10+50"
    padding = 10
    horizontal_padding = 10
    frame_width = 2
    frame_color = "#d65d0e"
    font = JetBrains Mono 10
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    icon_position = left
    max_icon_size = 32
    icon_theme = Papirus

[urgency_low]
    background = "#282828"
    foreground = "#a89984"
    timeout = 10

[urgency_normal]
    background = "#282828"
    foreground = "#ebdbb2"
    timeout = 10

[urgency_critical]
    background = "#282828"
    foreground = "#fb4934"
    frame_color = "#fb4934"
    timeout = 0

EOF
    
    print_success "Configuración de dunst creada"
fi

################################################################################
# HABILITACIÓN DE SERVICIOS SYSTEMD
################################################################################

print_header "HABILITACIÓN DE SERVICIOS SYSTEMD"

print_info "Habilitando servicio de NetworkManager..."
sudo systemctl enable NetworkManager 2>/dev/null || print_warning "NetworkManager no pudo ser habilitado"

print_info "Habilitando servicios de PipeWire..."
systemctl --user enable pipewire pipewire-pulse wireplumber 2>/dev/null || print_warning "Servicios de PipeWire no pudieron ser habilitados"
systemctl --user start pipewire pipewire-pulse wireplumber 2>/dev/null || print_warning "Servicios de PipeWire no pudieron ser iniciados"

print_success "Servicios habilitados"

################################################################################
# CONFIGURACIÓN DE XINITRC
################################################################################

print_header "CONFIGURACIÓN DE XINITRC"

XINITRC_FILE="${HOME}/.xinitrc"

if [[ ! -f "$XINITRC_FILE" ]]; then
    print_info "Creando archivo .xinitrc..."
    
    cat > "$XINITRC_FILE" << 'EOF'
#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

setxkbmap es
exec bspwm

EOF
    
    chmod +x "$XINITRC_FILE"
    print_success ".xinitrc creado"
fi

################################################################################
# CREACIÓN DE WALLPAPER
################################################################################

print_header "CREACIÓN DE FONDO DE PANTALLA"

WALLPAPER_DIR="${HOME}/.config/bspwm"
WALLPAPER_FILE="${WALLPAPER_DIR}/wallpaper.jpg"

if [[ ! -f "$WALLPAPER_FILE" ]]; then
    print_info "Creando fondo de pantalla..."
    
    if command -v convert &>/dev/null; then
        convert -size 1920x1080 gradient:282828-1d2021 "$WALLPAPER_FILE"
        print_success "Fondo de pantalla generado"
    else
        print_warning "ImageMagick no está instalado. Instálalo con: sudo pacman -S imagemagick"
    fi
fi

################################################################################
# INFORMACIÓN FINAL
################################################################################

print_header "INSTALACIÓN COMPLETADA"

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC} ✓ Instalación y configuración completadas con éxito"
echo -e "${GREEN}╠════════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}║${NC} Próximos pasos:"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC} 1. Verifica tu configuración:"
echo -e "${CYAN}║${NC}    • ~/.xinitrc"
echo -e "${CYAN}║${NC}    • ~/.config/bspwm/bspwmrc"
echo -e "${CYAN}║${NC}    • ~/.config/sxhkd/sxhkdrc"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC} 2. Inicia BSPWM:"
echo -e "${CYAN}║${NC}    • En TTY: startx"
echo -e "${CYAN}║${NC}    • O selecciona BSPWM en tu gestor de login"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}║${NC} 3. Atajos básicos:"
echo -e "${CYAN}║${NC}    • Super + Return: Terminal"
echo -e "${CYAN}║${NC}    • Super + d: Lanzador"
echo -e "${CYAN}║${NC}    • Super + w: Cerrar ventana"
echo -e "${CYAN}║${NC}    • Super + {1-10}: Cambiar espacio de trabajo"
echo -e "${GREEN}║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"

print_success "¡Disfruta tu nuevo entorno BSPWM!"
