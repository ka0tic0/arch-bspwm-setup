# Estructura del Repositorio arch-bspwm-setup

## Descripción General

Este repositorio contiene una solución completa y automatizada para instalar y configurar BSPWM en Arch Linux. Incluye scripts, configuraciones y documentación.

---

## 📁 Estructura de Archivos

```
arch-bspwm-setup/
├── README.md                           # Documentación principal
├── GUIA_PERSONALIZACION.md             # Guía completa de personalización
├── TROUBLESHOOTING.md                  # Solución de problemas
├── LICENSE                             # Licencia MIT
├── .gitignore                          # Archivos ignorados por Git
│
├── install-bspwm.sh                    # Script principal de instalación
├── uninstall-bspwm.sh                  # Script de desinstalación
│
├── themes/                             # Scripts de temas de color
│   ├── gruvbox-theme.sh               # Tema Gruvbox (predeterminado)
│   ├── dracula-theme.sh               # Tema Dracula
│   ├── onedark-theme.sh               # Tema OneDark
│   └── nord-theme.sh                  # Tema Nord
│
├── scripts/                            # Scripts auxiliares
│   ├── setup-aur.sh                   # Configurar yay (AUR helper)
│   ├── install-fonts.sh               # Instalar solo fuentes
│   └── customize.sh                   # Asistente interactivo de personalización
│
└── configs/                            # Archivos de configuración de referencia
    ├── bspwmrc                        # Configuración de BSPWM
    ├── sxhkdrc                        # Atajos de teclado
    ├── picom.conf                     # Configuración del compositor
    ├── polybar-config.ini             # Configuración de la barra de estado
    ├── rofi-config.rasi               # Configuración del lanzador
    ├── kitty.conf                     # Configuración de la terminal
    ├── dunstrc                        # Configuración de notificaciones
    └── .xinitrc                       # Configuración de inicio de X11
```

---

## 🚀 Flujo de Instalación

### 1. Preparación
```bash
git clone https://github.com/ka0tic0/arch-bspwm-setup.git
cd arch-bspwm-setup
chmod +x install-bspwm.sh
```

### 2. Instalación
```bash
./install-bspwm.sh
```

Este script automáticamente:
- Verifica que sea Arch Linux
- Instala/verifica yay
- Instala todos los paquetes necesarios
- Crea la estructura de directorios en `~/.config/`
- Genera archivos de configuración
- Configura autostart
- Habilita servicios necesarios

### 3. Inicio
```bash
startx  # O selecciona BSPWM en tu gestor de login
```

---

## 📚 Documentación

### README.md
- Descripción del proyecto
- Características principales
- Requisitos previos
- Instalación rápida
- Guía de uso básica
- Solución rápida de problemas comunes

### GUIA_PERSONALIZACION.md
- Cambio de colores y temas
- Configuración de atajos de teclado
- Personalización de Polybar
- Configuración de Kitty
- Comportamiento de BSPWM
- Scripts personalizados
- Tips avanzados

### TROUBLESHOOTING.md
- Problemas de instalación
- Problemas de inicio
- Problemas de aplicaciones
- Problemas de audio
- Problemas de red
- Problemas de rendimiento
- Debugging avanzado

---

## 🔧 Scripts Principales

### install-bspwm.sh
**Función:** Instalación y configuración completa de BSPWM

**Acciones:**
1. Verifica permisos (no root)
2. Valida que sea Arch Linux
3. Instala/verifica yay
4. Actualiza base de datos de paquetes
5. Instala paquetes por categoría:
   - X11 Core
   - Gestor de ventanas
   - Compositor y notificaciones
   - Barra y lanzador
   - Terminal y gestor de archivos
   - Apariencia
   - Red y audio
   - Fuentes
6. Crea estructura de directorios
7. Genera configuraciones
8. Configura autostart
9. Habilita servicios

### uninstall-bspwm.sh
**Función:** Desinstalación limpia de BSPWM

**Acciones:**
1. Elimina archivos de configuración
2. Opcionalmente desinstala paquetes
3. Solicita confirmación del usuario

---

## 🎨 Scripts de Temas

Cada script de tema:
1. Actualiza colores de BSPWM
2. Modifica Polybar
3. Configura Kitty
4. Actualiza Dunst
5. Reinicia servicios

**Temas disponibles:**
- **Gruvbox:** Colores cálidos, excelente para largas sesiones
- **Dracula:** Oscuro y vibrante
- **OneDark:** VS Code inspired
- **Nord:** Frío y minimalista

---

## 🔨 Scripts Auxiliares

### setup-aur.sh
Instala y configura yay si no está presente.

**Uso:**
```bash
bash scripts/setup-aur.sh
```

### install-fonts.sh
Instala solo las fuentes necesarias.

**Uso:**
```bash
bash scripts/install-fonts.sh
```

### customize.sh
Menú interactivo para personalizar BSPWM.

**Uso:**
```bash
bash scripts/customize.sh
```

---

## 📝 Archivos de Configuración

Todos los archivos de configuración están en `configs/` como referencia:

### bspwmrc
- Espacios de trabajo
- Bordes y espaciado
- Colores
- Reglas de ventanas
- Autostart de aplicaciones

### sxhkdrc
- Atajos de teclado (60+ atajos predefinidos)
- Control de aplicaciones
- Navegación de ventanas
- Control de audio
- Control de brillo

### picom.conf
- Backend gráfico
- Transparencias
- Sombras
- Animaciones
- Desenfoque (opcional)

### polybar-config.ini
- Altura y ancho de barra
- Colores
- Fuentes
- Módulos (CPU, RAM, Temp, Fecha)
- Área de notificación

### rofi-config.rasi
- Configuración del lanzador
- Colores
- Fuentes
- Modos (drun, run, window)

### kitty.conf
- Fuente (JetBrains Mono)
- Tema (Gruvbox)
- Opacidad
- Cursor
- Pañas

### dunstrc
- Posición y tamaño
- Colores por urgencia
- Fuentes
- Iconos
- Timeouts

### .xinitrc
- Configuración de teclado
- Variables de entorno
- Inicio de BSPWM

---

## 📦 Paquetes Instalados

### Core X11
- xorg
- xorg-xinit

### Gestor de Ventanas
- bspwm
- sxhkd

### Compositor y Notificaciones
- picom
- dunst

### Barra y Lanzador
- polybar
- rofi

### Terminal y Archivos
- kitty
- thunar

### Apariencia
- feh
- lxappearance
- arc-gtk-theme
- papirus-icon-theme

### Red y Audio
- networkmanager
- network-manager-applet
- pipewire
- pipewire-alsa
- pipewire-pulse
- pipewire-jack
- wireplumber

### Fuentes
- noto-fonts
- noto-fonts-emoji
- ttf-font-awesome
- ttf-jetbrains-mono-nerd (AUR)
- ttf-nerd-fonts-symbols (AUR)

---

## 🎯 Atajos de Teclado Principales

| Atajo | Acción |
|-------|--------|
| `Super + Return` | Abrir terminal (Kitty) |
| `Super + d` | Lanzador (Rofi) |
| `Super + w` | Cerrar ventana |
| `Super + f` | Fullscreen |
| `Super + Shift + f` | Modo flotante |
| `Super + {h,j,k,l}` | Navegar ventanas |
| `Super + {1-0}` | Cambiar espacio de trabajo |
| `Super + Ctrl + r` | Reiniciar BSPWM |
| `Super + Ctrl + q` | Salir de BSPWM |

---

## 🛠️ Personalización Rápida

### Cambiar Tema
```bash
bash themes/dracula-theme.sh
bash themes/onedark-theme.sh
bash themes/nord-theme.sh
```

### Cambiar Fondo de Pantalla
```bash
feh --bg-scale /ruta/a/imagen.jpg
```

### Editar Atajos
```bash
nano ~/.config/sxhkd/sxhkdrc
```

### Editar Barra
```bash
nano ~/.config/polybar/config.ini
```

---

## 📞 Soporte y Ayuda

1. **Revisa TROUBLESHOOTING.md** para problemas comunes
2. **Lee GUIA_PERSONALIZACION.md** para personalizar
3. **Abre un Issue** en GitHub para reportar bugs
4. **Consulta documentación oficial:**
   - [BSPWM](https://github.com/baskerville/bspwm)
   - [Polybar](https://github.com/polybar/polybar)
   - [Rofi](https://github.com/davatorium/rofi)
   - [Kitty](https://sw.kovidgoyal.net/kitty/)

---

## 📄 Licencia

MIT License - Libre de usar, modificar y distribuir

---

**Última actualización:** 2026-07-16
**Versión:** 1.0.0
