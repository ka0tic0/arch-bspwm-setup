# 🏗️ Arch Linux BSPWM - Entorno de Escritorio Automatizado

**Una solución completa y profesional para automatizar la instalación y configuración de BSPWM en Arch Linux**

---

## 📋 Tabla de Contenidos

- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Instalación Rápida](#instalación-rápida)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Guía de Uso](#guía-de-uso)
- [Personalización](#personalización)
- [Solución de Problemas](#solución-de-problemas)
- [Documentación Detallada](#documentación-detallada)

---

## ✨ Características

### 🎯 Automatización Completa
- ✅ Instalación de todos los paquetes necesarios (repositorios oficiales + AUR)
- ✅ Creación automática de estructura de directorios en `~/.config/`
- ✅ Generación inteligente de archivos de configuración
- ✅ Detección y instalación automática de `yay` si no está presente
- ✅ Manejo robusto de errores con `set -e`

### 🎨 Escritorio Funcional y Hermoso
- **Gestor de Ventanas**: BSPWM (tiling window manager)
- **Compositor**: Picom (transparencias, sombras, efectos)
- **Barra de Estado**: Polybar (información del sistema)
- **Lanzador**: Rofi (búsqueda y ejecución de aplicaciones)
- **Terminal**: Kitty (moderna, configurada con tema Gruvbox)
- **Notificaciones**: Dunst (sistema de alertas minimalista)
- **Gestor de Archivos**: Thunar (rápido y ligero)

### 🔒 Seguridad y Estabilidad
- No requiere permisos de root durante la ejecución (solo para sudo)
- Verifica la integridad del sistema (Arch Linux, permisos, etc.)
- Respeta archivos existentes sin sobrescribir configuraciones previas
- Incluye validación de paquetes antes de instalar

### 🌈 Personalización Simplificada
- Configuraciones basadas en tema Gruvbox (colores armoniosos)
- Atajos de teclado intuitivos predefinidos
- Fácil de modificar y extender
- Documentación inline en cada archivo de configuración

### 📦 Paquetes Completos

#### Core
- `xorg`, `xorg-xinit` (servidor gráfico X11)
- `bspwm`, `sxhkd` (gestor de ventanas y atajos)

#### Compositor y Notificaciones
- `picom` (compositor avanzado)
- `dunst` (demonio de notificaciones)

#### Barra y Lanzador
- `polybar` (barra de estado configurable)
- `rofi` (lanzador rápido)

#### Terminal y Archivos
- `kitty` (emulador de terminal moderno)
- `thunar` (gestor de archivos)

#### Apariencia
- `feh` (gestor de fondos de pantalla)
- `lxappearance` (gestor de temas GTK)
- `arc-gtk-theme` (tema GTK moderno)
- `papirus-icon-theme` (iconos de alta calidad)

#### Red y Audio
- `networkmanager`, `network-manager-applet` (gestión de red)
- `pipewire`, `pipewire-alsa`, `pipewire-pulse`, `pipewire-jack`, `wireplumber` (sistema de audio moderno)

#### Fuentes
- `ttf-jetbrains-mono-nerd` (fuente principal, AUR)
- `ttf-nerd-fonts-symbols` (símbolos, AUR)
- `noto-fonts`, `noto-fonts-emoji`, `ttf-font-awesome` (complementarias)

---

## 📋 Requisitos Previos

### Sistema Base
- **Arch Linux** instalado y funcional
- **Conexión a Internet** (para descargar paquetes)
- **Usuario regular** (con permisos de sudo)

### Preparación Inicial
```bash
# Asegurar que sudo está configurado sin contraseña (opcional pero recomendado)
# O ten tu contraseña lista para ingresar cuando se solicite

# Actualizar el sistema (recomendado)
sudo pacman -Syu

# Asegurar que tienes git (para clonar este repositorio)
sudo pacman -S git
```

---

## 🚀 Instalación Rápida

### Opción 1: Clonar desde GitHub (Recomendado)

```bash
# Clonar el repositorio
git clone https://github.com/ka0tic0/arch-bspwm-setup.git
cd arch-bspwm-setup

# Hacer el script ejecutable
chmod +x install-bspwm.sh

# Ejecutar el script de instalación
./install-bspwm.sh
```

### Opción 2: Descargar Directamente

```bash
# Descargar solo el script principal
wget https://raw.githubusercontent.com/ka0tic0/arch-bspwm-setup/main/install-bspwm.sh
chmod +x install-bspwm.sh
./install-bspwm.sh
```

### Opción 3: One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/ka0tic0/arch-bspwm-setup/main/install-bspwm.sh | bash
```

---

## 📁 Estructura del Proyecto

```
arch-bspwm-setup/
├── README.md                      # Documentación principal
├── GUIA_PERSONALIZACION.md        # Guía completa de personalización
├── TROUBLESHOOTING.md             # Solución de problemas comunes
├── LICENSE                        # Licencia MIT
├── .gitignore                     # Archivos ignorados por git
├── install-bspwm.sh              # Script principal de instalación
├── uninstall-bspwm.sh            # Script para desinstalar y limpiar
├── themes/                        # Temas alternativos
│   ├── dracula-theme.sh          # Tema Dracula (oscuro y vibrante)
│   ├── onedark-theme.sh          # Tema OneDark (VS Code inspired)
│   └── nord-theme.sh             # Tema Nord (frío y minimalista)
├── configs/                       # Archivos de configuración de referencia
│   ├── bspwmrc                   # Configuración de BSPWM
│   ├── sxhkdrc                   # Atajos de teclado
│   ├── picom.conf                # Configuración del compositor
│   ├── polybar-config.ini        # Configuración de la barra
│   ├── rofi-config.rasi          # Configuración del lanzador
│   ├── kitty.conf                # Configuración de la terminal
│   ├── dunstrc                   # Configuración de notificaciones
│   └── .xinitrc                  # Archivo de inicio de X11
└── scripts/                       # Scripts auxiliares
    ├── setup-aur.sh              # Configurar AUR helper (yay)
    ├── install-fonts.sh          # Instalar solo fuentes
    └── customize.sh              # Asistente de personalización interactivo
```

---

## 🎯 Guía de Uso

### Paso 1: Ejecutar el Script de Instalación

```bash
./install-bspwm.sh
```

El script hará automáticamente:
1. ✓ Verificar que no se ejecuta como root
2. ✓ Validar que sea Arch Linux
3. ✓ Instalar/verificar yay
4. ✓ Descargar e instalar todos los paquetes
5. ✓ Crear estructura de directorios
6. ✓ Generar archivos de configuración
7. ✓ Configurar autostart
8. ✓ Habilitar servicios necesarios

### Paso 2: Reiniciar el Sistema (Recomendado)

```bash
sudo reboot
```

### Paso 3: Iniciar BSPWM

#### Opción A: Desde TTY (Virtual Console)
```bash
# En la pantalla de login de TTY:
startx
```

#### Opción B: Con un Display Manager (GDM, SDDM, LightDM, etc.)

Si tienes un gestor de login gráfico instalado:
1. Selecciona **BSPWM** de la lista de sesiones
2. Ingresa tu contraseña
3. ¡Disfruta tu nuevo entorno!

### Paso 4: Verificar la Instalación

Una vez en BSPWM, prueba estos atajos:

```
Super (Windows) + Return          → Abre Kitty (terminal)
Super + d                         → Abre Rofi (lanzador)
Super + w                         → Cierra la ventana actual
Super + f                         → Toggle fullscreen
Super + Shift + f                 → Toggle modo flotante
Super + {h,j,k,l}               → Navega entre ventanas
Super + {1-9,0}                 → Cambia a espacio de trabajo
Super + Ctrl + r                → Reinicia BSPWM
Super + Ctrl + q                → Cierra BSPWM
```

---

## 🎨 Personalización

### Cambio Rápido de Tema

El proyecto incluye scripts para cambiar temas sin reinstalar:

```bash
# Aplicar tema Dracula
./themes/dracula-theme.sh

# Aplicar tema OneDark
./themes/onedark-theme.sh

# Aplicar tema Nord
./themes/nord-theme.sh

# Asistente interactivo de personalización
./scripts/customize.sh
```

### Personalización Manual

Para instrucciones detalladas sobre cómo personalizar:
- **Colores y temas**: Ver `GUIA_PERSONALIZACION.md`
- **Atajos de teclado**: Edita `~/.config/sxhkd/sxhkdrc`
- **Barra de estado**: Edita `~/.config/polybar/config.ini`
- **Terminal**: Edita `~/.config/kitty/kitty.conf`
- **Comportamiento de ventanas**: Edita `~/.config/bspwm/bspwmrc`

---

## 🔧 Configuración Post-Instalación

### 1. Establecer Teclado Correcto

Edita `~/.xinitrc` y cambia la línea:

```bash
setxkbmap es  # Cambiar 'es' por tu distribución (us, de, fr, etc.)
```

### 2. Cambiar el Wallpaper

```bash
# Opción A: Usar una imagen existente
feh --bg-scale /ruta/a/tu/imagen.jpg

# Opción B: Usar el gestor de fondos de Thunar
# Haz clic derecho en la imagen en el gestor de archivos

# Opción C: Hacer que sea permanente
echo "feh --bg-scale /ruta/a/tu/imagen.jpg" >> ~/.config/bspwm/bspwmrc
```

### 3. Instalar Aplicaciones Adicionales

```bash
# Navegador
sudo pacman -S firefox

# Editor de texto
sudo pacman -S neovim

# Media player
sudo pacman -S vlc

# Editor de imágenes
sudo pacman -S gimp
```

### 4. Configurar Audio

PipeWire ya está instalado y configurado. Para verificar:

```bash
# Ver dispositivos de audio
pactl list short sinks

# Controlar volumen (recomendamos instalar pavucontrol)
sudo pacman -S pavucontrol
pavucontrol
```

### 5. Configurar Red

NetworkManager ya está habilitado. Para usar:

```bash
# Abre el applet de red (Super + d, busca nm-applet)
# O accede desde la barra de estado (polybar)
```

---

## 🆘 Solución de Problemas

### El script no se ejecuta

```bash
# Error: Permission denied
chmod +x install-bspwm.sh

# Error: command not found
# Asegúrate de estar en el directorio correcto
pwd
ls -la install-bspwm.sh
```

### BSPWM no inicia

```bash
# Verifica que .xinitrc existe y es ejecutable
ls -la ~/.xinitrc

# Reinicia el servicio X
sudo systemctl restart display-manager

# O inicia manualmente desde TTY
startx
```

### Polybar no aparece

```bash
# Verifica que la configuración existe
cat ~/.config/polybar/config.ini

# Inicia polybar manualmente
~/.config/polybar/launch.sh

# Verifica errores en la terminal
polybar mybar 2>&1 | head -20
```

### Atajos de teclado no funcionan

```bash
# Reinicia sxhkd
pkill sxhkd
sxhkd &

# Verifica que los atajos están definidos
cat ~/.config/sxhkd/sxhkdrc | grep "super"
```

### Fuentes no se ven correctamente

```bash
# Reconstruir cache de fuentes
fc-cache -fv

# Listar fuentes instaladas
fc-list | grep "JetBrains"

# Reinstalar fuentes si es necesario
yay -S ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols
```

### Audio no funciona

```bash
# Verificar que PipeWire está corriendo
systemctl --user status pipewire

# Si no está activo:
systemctl --user start pipewire pipewire-pulse wireplumber

# Verificar con pactl
pactl info

# Ver volumen actual
pactl get-sink-volume @DEFAULT_SINK@
```

Para más problemas, consulta **`TROUBLESHOOTING.md`**

---

## 📚 Documentación Detallada

### Archivos de Documentación

| Archivo | Contenido |
|---------|----------|
| `GUIA_PERSONALIZACION.md` | Guía completa de personalización (colores, fuentes, atajos, comportamiento) |
| `TROUBLESHOOTING.md` | Solución de problemas comunes y avanzados |
| `CONFIGS_EXPLAINED.md` | Explicación detallada de cada archivo de configuración |

### Documentación de Comandos

```bash
# BSPWM
man bspwm              # Manual de BSPWM
man bspc               # Herramienta de control

# SXHKD
man sxhkd              # Manual de atajos de teclado

# Polybar
polybar --help
polybar --list-modules

# Rofi
rofi -help
rofi -show drun

# Kitty
kitty --help
man kitty

# PipeWire
man pactl              # Control de audio
```

---

## 🧹 Desinstalación

Si necesitas desinstalar el entorno BSPWM:

```bash
# Usar el script de desinstalación incluido
./uninstall-bspwm.sh

# O hacer limpieza manual
# Eliminar archivos de configuración
rm -rf ~/.config/bspwm
rm -rf ~/.config/sxhkd
rm -rf ~/.config/polybar
rm -rf ~/.config/rofi
rm -rf ~/.config/kitty
rm -rf ~/.config/picom
rm -rf ~/.config/dunst

# Desinstalar paquetes (opcional)
sudo pacman -R bspwm sxhkd picom dunst polybar rofi kitty thunar feh lxappearance arc-gtk-theme papirus-icon-theme
```

---

## 💡 Tips y Trucos

### 1. Aumentar la velocidad de repetición de teclado

```bash
# En .xinitrc, antes de "exec bspwm"
xset r rate 200 50  # delay=200ms, rate=50 repeticiones/segundo
```

### 2. Usar múltiples monitores

```bash
# En bspwmrc, después de líneas de configuración
bspc monitor HDMI-1 -d 1 2 3 4 5
bspc monitor DP-1 -d 6 7 8 9 10

# O configurar automáticamente
~/.config/polybar/launch.sh
```

### 3. Crear atajos personalizados

```bash
# Edita ~/.config/sxhkd/sxhkdrc

# Ejemplo: Abrir aplicación con atajo
super + shift + n
    firefox

# Ejemplo: Script personalizado
super + shift + s
    ~/.local/bin/mi-script.sh
```

### 4. Cambiar tema sin reinstalar

```bash
# Ver GUIA_PERSONALIZACION.md para instrucciones
./themes/dracula-theme.sh
```

### 5. Exportar configuración

```bash
# Respaldar tu configuración
tar -czf bspwm-backup-$(date +%Y%m%d).tar.gz ~/.config/bspwm ~/.config/sxhkd ~/.config/polybar

# Restaurar desde backup
tar -xzf bspwm-backup-YYYYMMDD.tar.gz -C ~/
```

---

## 🤝 Contribuciones

¿Encontraste un error? ¿Tienes una idea de mejora?

1. Fork el repositorio
2. Crea una rama: `git checkout -b mi-mejora`
3. Realiza tus cambios
4. Commit: `git commit -am 'Añadir mi mejora'`
5. Push: `git push origin mi-mejora`
6. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo licencia **MIT**. Eres libre de:
- ✓ Usar el proyecto
- ✓ Modificarlo
- ✓ Distribuirlo
- ✓ Usarlo comercialmente

Con la única condición de incluir la licencia original.

---

## 📞 Soporte

Si necesitas ayuda:

1. **Revisa TROUBLESHOOTING.md** - Soluciona problemas comunes
2. **Lee GUIA_PERSONALIZACION.md** - Aprende a personalizar
3. **Abre un Issue** - Reporta bugs o solicita funcionalidades
4. **Consulta la documentación de cada proyecto**:
   - [BSPWM Wiki](https://github.com/baskerville/bspwm)
   - [Polybar GitHub](https://github.com/polybar/polybar)
   - [Rofi GitHub](https://github.com/davatorium/rofi)
   - [Kitty Docs](https://sw.kovidgoyal.net/kitty/)

---

## 🌟 Agradecimientos

Este proyecto fue inspirado por:
- La comunidad de Arch Linux
- Usuarios de tiling window managers
- Desarrolladores de BSPWM, Polybar, Rofi y herramientas asociadas

---

## 📈 Roadmap

Funcionalidades planeadas:
- [ ] Interfaz gráfica de instalación
- [ ] Más temas pre-configurados
- [ ] Sistema de plugins para extensiones
- [ ] Gestor de dotfiles automático
- [ ] Soporte para configuración de múltiples monitores
- [ ] Asistente de actualización

---

**Última actualización:** 2026-07-16
**Versión:** 1.0.0

---

**¡Disfruta tu nuevo entorno BSPWM! 🎉**