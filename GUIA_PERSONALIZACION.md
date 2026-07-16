# 🎨 Guía Completa de Personalización - BSPWM

**Aprende a personalizar cada aspecto de tu entorno BSPWM**

---

## 📋 Tabla de Contenidos

- [Cambio de Colores y Temas](#cambio-de-colores-y-temas)
- [Configuración de Atajos de Teclado](#configuración-de-atajos-de-teclado)
- [Personalización de Polybar](#personalización-de-polybar)
- [Configuración de Kitty](#configuración-de-kitty)
- [Comportamiento de BSPWM](#comportamiento-de-bspwm)
- [Temas Predefinidos](#temas-predefinidos)
- [Aplicar Fondos de Pantalla](#aplicar-fondos-de-pantalla)
- [Scripts Personalizados](#scripts-personalizados)

---

## 🎨 Cambio de Colores y Temas

### Paletas de Colores Disponibles

El proyecto incluye tres temas principales:

#### 1. **Gruvbox** (Predeterminado)

Colores cálidos y armoniosos, excelente para largas sesiones de trabajo.

```bash
# Colores principales:
Background: #282828
Foreground: #ebdbb2
Primary: #98c379 (Verde)
Secondary: #e06c75 (Rojo)
```

#### 2. **Dracula**

Oscuro y vibrante, con colores contrastantes.

```bash
./themes/dracula-theme.sh

# Colores principales:
Background: #282a36
Foreground: #f8f8f2
Primary: #50fa7b (Verde)
Secondary: #ff79c6 (Magenta)
```

#### 3. **Nord**

Frío y minimalista, colores árticos.

```bash
./themes/nord-theme.sh

# Colores principales:
Background: #2e3440
Foreground: #eceff4
Primary: #a3be8c (Verde)
Secondary: #bf616a (Rojo)
```

#### 4. **OneDark**

Inspired en VS Code, moderno y profesional.

```bash
./themes/onedark-theme.sh

# Colores principales:
Background: #282c34
Foreground: #abb2bf
Primary: #98c379 (Verde)
Secondary: #e06c75 (Rojo)
```

### Aplicar Temas Rápidamente

```bash
# Ir al directorio del proyecto
cd arch-bspwm-setup

# Aplicar tema Dracula
bash themes/dracula-theme.sh

# Aplicar tema Nord
bash themes/nord-theme.sh

# Aplicar tema OneDark
bash themes/onedark-theme.sh

# Volver a Gruvbox (predeterminado)
bash themes/gruvbox-theme.sh
```

### Crear Tu Propio Tema

Crea un archivo `~/.config/bspwm/theme.sh`:

```bash
#!/bin/bash

# Define tus colores
COLOR_BG="#1a1a1a"
COLOR_FG="#ffffff"
COLOR_PRIMARY="#00ff00"
COLOR_SECONDARY="#ff0000"

# Aplicar a BSPWM
bspc config normal_border_color "#555555"
bspc config active_border_color "$COLOR_SECONDARY"
bspc config focused_border_color "$COLOR_PRIMARY"

# Aplicar a Polybar (edita ~/.config/polybar/config.ini)
# Cambiar las secciones [colors] con tus valores

# Aplicar a Kitty (edita ~/.config/kitty/kitty.conf)
# Cambiar valores de foreground y background

# Aplicar a Dunst (edita ~/.config/dunst/dunstrc)
# Cambiar background y foreground en cada sección [urgency_*]
```

---

## ⌨️ Configuración de Atajos de Teclado

### Ubicación del Archivo

```bash
~/.config/sxhkd/sxhkdrc
```

### Sintaxis Básica

```bash
# Atajo simple
super + Return
    kitty

# Atajo con modificadores múltiples
super + shift + q
    xdotool key super+ctrl+q

# Atajo con iteración
super + {1-9,0}
    bspc desktop -f '^{1-9,10}'

# Atajo con alternancia (|)
super + {h,l}
    bspc node -f {west,east}
```

### Modificadores Disponibles

| Modificador | Tecla |
|-------------|-------|
| `super` | Tecla Windows |
| `alt` | Alt |
| `ctrl` | Control |
| `shift` | Mayúsculas |
| `mod5` | AltGr |

### Ejemplos de Atajos Personalizados

#### Abrir Aplicaciones

```bash
# Firefox
super + shift + f
    firefox

# Navegador alternativo
super + shift + c
    chromium

# Editor de texto
super + shift + e
    nano ~/.config/bspwm/bspwmrc

# Gestor de archivos
super + shift + m
    thunar
```

#### Control de Audio

```bash
# Aumentar volumen
superplus + plus
    pactl set-sink-volume @DEFAULT_SINK@ +5%

# Disminuir volumen
super + minus
    pactl set-sink-volume @DEFAULT_SINK@ -5%

# Mutear
super + m
    pactl set-sink-mute @DEFAULT_SINK@ toggle
```

#### Control de Brillo (para laptop)

```bash
# Aumentar brillo
super + bracketright
    brightnessctl set +5%

# Disminuir brillo
super + bracketleft
    brightnessctl set 5%-
```

#### Captura de Pantalla

```bash
# Screenshot completo
Print
    import -window root ~/Pictures/screenshot-$(date +%s).png

# Screenshot de área seleccionada
shift + Print
    import ~/Pictures/screenshot-$(date +%s).png
```

#### Scripts Personalizados

```bash
# Ejecutar script personalizado
super + shift + p
    ~/.local/bin/mi-script.sh

# Función del script
super + shift + l
    bspc quit && startx
```

### Recargar Atajos sin Reiniciar

```bash
# Reiniciar sxhkd
pkill -f sxhkd; sxhkd -c ~/.config/sxhkd/sxhkdrc &

# O simplemente
pkill sxhkd
# Los atajos se recargarán cuando BSPWM se reinicie
```

---

## 📊 Personalización de Polybar

### Ubicación del Archivo

```bash
~/.config/polybar/config.ini
```

### Cambiar Altura de la Barra

```ini
[bar/mybar]
height = 35  ; Aumentar de 27 a 35 píxeles
```

### Agregar Módulos

```ini
; Agregar módulo de CPU
modules-right = cpu memory temperature date

[module/cpu]
type = internal/cpu
interval = 1
format = <label>
label = CPU: %percentage:2%%
```

### Cambiar Colores

```ini
[colors]
background = #1a1a1a      ; Fondo más oscuro
foreground = #ffffff      ; Texto blanco
primary = #00ff00         ; Verde neon
secondary = #ff00ff       ; Magenta
alert = #ff0000           ; Rojo
```

### Personalizar Fuentes

```ini
[bar/mybar]
font-0 = "Monospace:pixelsize=12;2"
font-1 = "Font Awesome 6:pixelsize=12;2"
font-2 = "Noto Color Emoji:pixelsize=12;2"
```

### Mover Barra a Posición Inferior

```ini
[bar/mybar]
bottom = true
```

### Hacer Barra Transparente

```ini
[bar/mybar]
background = #00000000  ; Formato: #AARRGGBB
```

---

## 🖥️ Configuración de Kitty

### Ubicación del Archivo

```bash
~/.config/kitty/kitty.conf
```

### Cambiar Tema de Color

```bash
# Usar temas predefinidos
include /home/usuario/.config/kitty/themes/Dracula.conf

# O definir colores manualmente
foreground            #ffffff
background            #000000
```

### Opacidad

```bash
# 1.0 = opaco, 0.0 = transparente
background_opacity    0.85

# Opacidad dinámicamente al compilar
background_opacity    0.9 0.8 0.7
```

### Tamaño de Fuente

```bash
font_family      JetBrains Mono
font_size        13
```

### Cursor

```bash
cursor_shape        block      # block, beam, underline
cursor_blink_interval 0        # 0 = sin parpadeo
```

### Atajos en Kitty

```bash
# Abrir gestor de archivos
map ctrl+alt+f launch --type=os-window thunar

# Nueva pestaña
map ctrl+shift+t new_tab

# Nueva ventana
map ctrl+shift+n new_window
```

---

## ⚙️ Comportamiento de BSPWM

### Ubicación del Archivo

```bash
~/.config/bspwm/bspwmrc
```

### Cambiar Número de Espacios de Trabajo

```bash
# Predeterminado: 10 espacios (1-10)
bspc monitor -d 1 2 3 4 5 6 7 8 9 10

# Cambiar a 6 espacios
bspc monitor -d I II III IV V VI
```

### Cambiar Espaciado Entre Ventanas

```bash
bspc config window_gap 12   # Cambiar a 20 para más espacio
bspc config border_width 2  # Ancho del borde
```

### Cambiar Colores de Bordes

```bash
bspc config normal_border_color "#3c3836"
bspc config active_border_color "#83a598"
bspc config focused_border_color "#b8bb26"
```

### Comportamiento de Ventanas Flotantes

```bash
bspc config split_ratio 0.52          # Ratio de división
bspc config automatic_scheme alternate # Esquema automático
bspc config click_to_focus button1    # Click para enfocar
bspc config focus_follows_pointer false # No seguir mouse
```

### Reglas de Ventanas

```bash
# Firefox siempre en espacio de trabajo 2
bspc rule -a Firefox desktop='^2'

# GIMP en modo flotante
bspc rule -a Gimp state=floating

# VLC en fullscreen
bspc rule -a vlc state=fullscreen

# Aplicaciones específicas en flotante
bspc rule -a ".*\.exe" state=floating
```

### Disposición Predeterminada

```bash
# Alterna entre tiling y stacking
bspc config initial_split_ratio 0.5

# Enfoque automático en nueva ventana
bspc config automatic_scheme spiral
```

---

## 🎭 Temas Predefinidos

### Script de Tema: Estructura Básica

```bash
#!/bin/bash

# Colores
BG="#1a1a1a"
FG="#ffffff"
PRIMARY="#00ff00"
SECONDARY="#ff0000"

# 1. Actualizar BSPWM
echo "Actualizando BSPWM..."
bspc config normal_border_color "#333333"
bspc config active_border_color "$SECONDARY"
bspc config focused_border_color "$PRIMARY"

# 2. Actualizar Polybar
echo "Actualizando Polybar..."
sed -i "s/background = .*/background = $BG/" ~/.config/polybar/config.ini
sed -i "s/foreground = .*/foreground = $FG/" ~/.config/polybar/config.ini

# 3. Actualizar Kitty
echo "Actualizando Kitty..."
sed -i "s/foreground .*/foreground $FG/" ~/.config/kitty/kitty.conf
sed -i "s/background .*/background $BG/" ~/.config/kitty/kitty.conf

# 4. Reiniciar servicios
echo "Reiniciando servicios..."
pkill polybar
~/.config/polybar/launch.sh &

echo "Tema aplicado exitosamente"
```

---

## 🖼️ Aplicar Fondos de Pantalla

### Cambiar Fondo Permanentemente

```bash
# Opción 1: Editar bspwmrc
echo "feh --bg-scale /ruta/a/imagen.jpg" >> ~/.config/bspwm/bspwmrc

# Opción 2: Hacer la imagen permanente
feh --bg-scale --randomize ~/Imágenes/*.jpg &
```

### Usar Wallpaper Aleatorio

```bash
# Agregar a bspwmrc:
feh --bg-scale --randomize ~/Imágenes/*.jpg
```

### Obtener Wallpapers

```bash
# Descargar colecciones
git clone https://github.com/NvChad/nvchad-wallpapers.git ~/Imágenes/wallpapers

# Usar con feh
feh --bg-scale ~/Imágenes/wallpapers/random.jpg
```

---

## 📝 Scripts Personalizados

### Crear Scripts en ~/.local/bin

```bash
mkdir -p ~/.local/bin
```

### Ejemplo: Script de Volumen

```bash
#!/bin/bash
# ~/.local/bin/volume.sh

case $1 in
    up)    pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    down)  pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    mute)  pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
esac
```

### Ejemplo: Script de Apagado Rápido

```bash
#!/bin/bash
# ~/.local/bin/shutdown-menu.sh

SELECCION=$(echo -e "Cancelar\nApagar\nReiniciar\nHibernación" | rofi -dmenu -p "Acciones:")

case "$SELECCION" in
    Apagar) systemctl poweroff ;;
    Reiniciar) systemctl reboot ;;
    Hibernación) systemctl hibernate ;;
esac
```

### Hacer Scripts Ejecutables

```bash
chmod +x ~/.local/bin/*.sh
```

### Usar en Atajos

```bash
# En ~/.config/sxhkd/sxhkdrc
super + shift + p
    ~/.local/bin/volume.sh up
```

---

## 🔍 Consejos Avanzados

### 1. Multi-Monitor Setup

```bash
# En bspwmrc
bspc monitor HDMI-1 -d I II III
bspc monitor DP-1 -d IV V VI VII
```

### 2. Velocidad de Repetición de Teclado

```bash
# En ~/.xinitrc antes de exec bspwm
xset r rate 200 50  # delay=200ms, rate=50 repeticiones/segundo
```

### 3. Incrementar Limite de Archivos Abiertos

```bash
ulimit -n 4096
```

### 4. Optimizar Picom

```bash
# En ~/.config/picom/picom.conf
backend = "xrender";  # Cambiar a xrender para mejor rendimiento
```

### 5. Historial de Comandos en Rofi

```bash
# En ~/.config/sxhkd/sxhkdrc
super + shift + d
    rofi -show run
```

---

## 📚 Recursos Adicionales

- [BSPWM Wiki](https://github.com/baskerville/bspwm/wiki)
- [Polybar Documentation](https://polybar.readthedocs.io/)
- [Rofi Documentation](https://davatorium.github.io/rofi/)
- [Sxhkd Manual](https://wiki.archlinux.org/title/Sxhkd)
- [Kitty Documentation](https://sw.kovidgoyal.net/kitty/)

---

**¡Personalizaciones ilimitadas! 🚀**
