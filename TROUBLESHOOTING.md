# 🆘 Troubleshooting - Solución de Problemas

**Guía completa para resolver problemas comunes en BSPWM**

---

## 📋 Tabla de Contenidos

- [Problemas de Instalación](#problemas-de-instalación)
- [Problemas de Inicio](#problemas-de-inicio)
- [Problemas de Aplicaciones](#problemas-de-aplicaciones)
- [Problemas de Audio](#problemas-de-audio)
- [Problemas de Red](#problemas-de-red)
- [Problemas de Rendimiento](#problemas-de-rendimiento)
- [Problemas de Configuración](#problemas-de-configuración)
- [Debugging Avanzado](#debugging-avanzado)

---

## ⚙️ Problemas de Instalación

### Error: "Permission denied"

```bash
# Solución:
chmod +x install-bspwm.sh
./install-bspwm.sh
```

### Error: "Este script se ejecuta como root"

```bash
# ❌ NO hagas esto:
sudo ./install-bspwm.sh

# ✅ Hazlo así:
./install-bspwm.sh

# El script pedirá sudo cuando lo necesite
```

### Error: "Este es de solo lectura"

```bash
# Si el repositorio está clonado como solo lectura:
chmod u+w -R arch-bspwm-setup/
```

### Error: "No se encontró yay"

```bash
# Instalar manualmente:
sudo pacman -S base-devel git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Error: "No es Arch Linux"

```bash
# El script solo funciona en Arch Linux
# Para otras distros, instala los paquetes manualmente:
# Ubuntu/Debian: apt install bspwm sxhkd picom ...
# Fedora: dnf install bspwm sxhkd picom ...
```

### Error: "Problema de conexión a Internet"

```bash
# Verificar conexión:
ping -c 3 archlinux.org

# Si no hay conexión:
# Conectar a WiFi manualmente
wifi-menu

# O conectar por Ethernet y reintentar
```

---

## 🚀 Problemas de Inicio

### BSPWM no inicia desde TTY

```bash
# 1. Verificar que .xinitrc existe y es ejecutable
ls -la ~/.xinitrc

# 2. Si no existe, crear:
cat > ~/.xinitrc << 'EOF'
#!/bin/bash
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi
exec bspwm
EOF

chmod +x ~/.xinitrc

# 3. Intentar de nuevo:
startx
```

### Pantalla negra después de startx

```bash
# Presionar Alt+F2 para abrir tty virtual
# Ejecutar comandos:
ps aux | grep bspwm

# Si no está corriendo, verificar logs:
cat ~/.local/share/xorg/Xvfb-0.log

# Reintentar:
startx

# Si sigue sin funcionar, verificar instalación de xorg:
sudo pacman -S xorg xorg-xinit
```

### BSPWM no aparece en gestor de login

```bash
# Crear/verificar archivo de sesión:
sudo cat > /usr/share/xsessions/bspwm.desktop << 'EOF'
[Desktop Entry]
Name=BSPWM
Comment=Binary Space Partition Window Manager
Exec=bspwm
Type=Application
Keywords=wm;tiling;
EOF

# Reiniciar sesión gráfica o reiniciar máquina
```

### Error: "Cannot connect to display"

```bash
# Problema: X11 no está iniciado
# Solución:
startx

# Si persiste, verificar variables de entorno:
echo $DISPLAY
# Debería mostrar algo como :0, :1, etc.

# Si está vacío:
export DISPLAY=:0
```

---

## 📱 Problemas de Aplicaciones

### Polybar no aparece

```bash
# 1. Verificar que el archivo de configuración existe
cat ~/.config/polybar/config.ini

# 2. Verificar que polybar está instalado
polybar --version

# 3. Inicia polybar manualmente
polybar mybar

# 4. Si hay errores, intenta:
polybar mybar 2>&1 | head -30

# 5. Solución común: Reinicia BSPWM
super + ctrl + r

# 6. O ejecuta el script de lanzamiento:
~/.config/polybar/launch.sh
```

### Rofi no responde

```bash
# 1. Verificar que rofi está instalado
rofi --version

# 2. Probar manualmente
rofi -show drun

# 3. Si falla, verificar configuración
cat ~/.config/rofi/config.rasi

# 4. Resetear a configuración por defecto
rm ~/.config/rofi/config.rasi
rofi -help
```

### Kitty no abre

```bash
# 1. Verificar instalación
kitty --version

# 2. Abrir desde terminal existente
kitty &

# 3. Verificar configuración
cat ~/.config/kitty/kitty.conf

# 4. Si hay error de fuente:
fc-cache -fv  # Reconstruir cache de fuentes

# 5. Usar fuente por defecto temporalmente
kitty --override font_family=monospace
```

### Thunar lento

```bash
# Limpiar cache
rm -rf ~/.cache/Thunar/*

# Actualizar base de datos de archivos
update-desktop-database ~/.local/share/applications/

# Usar alternativa: PCManFM
sudo pacman -S pcmanfm
```

### Firefox se abre muy lentamente

```bash
# Opción 1: Desactivar composición en Firefox
# about:config > layers.acceleration.enabled = false

# Opción 2: Mejorar configuración de X11
# En ~/.config/picom/picom.conf:
backend = "xrender"

# Opción 3: Reiniciar Firefox
pkill firefox
firefox &
```

---

## 🔊 Problemas de Audio

### No hay sonido

```bash
# 1. Verificar que PipeWire está corriendo
systemctl --user status pipewire

# 2. Si no está activo, iniciarlo:
systemctl --user start pipewire pipewire-pulse wireplumber

# 3. Verificar dispositivos de audio
pactl list short sinks

# 4. Ver volumen actual
pactl get-sink-volume @DEFAULT_SINK@

# 5. Aumentar volumen si está bajo
pactl set-sink-volume @DEFAULT_SINK@ 100%
```

### Sonido muy bajo

```bash
# Opción 1: Aumentar volumen del sistema
pactl set-sink-volume @DEFAULT_SINK@ 150%

# Opción 2: Usar interfaz gráfica
sudo pacman -S pavucontrol
pavucontrol

# Opción 3: Amplificar en alsamixer
alsamixer
# Navegar con flechas, ajustar con +/-
```

### Sonido solo en uno de los altavoces

```bash
# Verificar canales en alsamixer
alsamixer
# Buscar controles de balance/mixing

# O usar pactl:
pactl list sink-inputs
pactl set-sink-input-mute <INDEX> toggle
```

### Problemas con auriculares

```bash
# Reconectar dispositivos de audio
sudo systemctl restart pulseaudio

# O con PipeWire:
systemctl --user restart pipewire

# Verificar en pavucontrol
pavucontrol
# Cambiar dispositivo de salida en pestaña "Output Devices"
```

### Micrófono no funciona

```bash
# 1. Verificar entrada de audio
pactl list short sources

# 2. Aumentar volumen de entrada
pactl set-source-volume @DEFAULT_SOURCE@ 100%

# 3. Verificar en pavucontrol
pavucontrol
# Ir a "Input Devices" y verificar nivel
```

---

## 🌐 Problemas de Red

### WiFi no funciona

```bash
# 1. Verificar NetworkManager
sudo systemctl status NetworkManager

# 2. Si no está activo:
sudo systemctl start NetworkManager

# 3. Verificar conexión disponible
nmcli device wifi list

# 4. Conectar a WiFi
nmcli device wifi connect SSID password PASSWORD

# 5. O usar applet gráfico (buscar nm-applet)
nm-applet &
```

### Sin conexión a Internet

```bash
# 1. Verificar IP
ip addr show

# 2. Verificar gateway
ip route show

# 3. Probar conectividad
ping 8.8.8.8

# 4. Si responde pero no hay DNS:
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null

# 5. Probar DNS
ping google.com
```

---

## ⚡ Problemas de Rendimiento

### BSPWM usa mucho CPU

```bash
# 1. Desactivar compositor (picom)
pkill picom

# 2. Verificar procesos
htop
# Buscar procesos que usan mucho CPU

# 3. Optimizar picom
# En ~/.config/picom/picom.conf
backend = "xrender"  # Cambiar de glx a xrender
vsync = false        # Desactivar si causa lag
blur-background = false  # Desactivar desenfoque
```

### Uso alto de RAM

```bash
# 1. Identificar culpables
free -h
top -o %MEM

# 2. Cerrar aplicaciones innecesarias
pkill firefox  # O la aplicación que consume mucho

# 3. Limpiar cache de paquetes
sudo pacman -Sc

# 4. Verificar logs
journalctl -p err -b
```

### BSPWM lento con muchas ventanas

```bash
# 1. Reducir número de escritorios
# En ~/.config/bspwm/bspwmrc:
bspc monitor -d 1 2 3 4 5  # Usar menos espacios

# 2. Desactivar animaciones en Polybar
# En ~/.config/polybar/config.ini:
transition-length = 0  # En lugar de 300

# 3. Desactivar picom si es necesario
pkill picom
```

---

## 🔧 Problemas de Configuración

### Atajos de teclado no funcionan

```bash
# 1. Verificar que sxhkd está corriendo
ps aux | grep sxhkd

# 2. Si no está:
sxhkd -c ~/.config/sxhkd/sxhkdrc &

# 3. Verificar sintaxis del archivo
cat ~/.config/sxhkd/sxhkdrc | head -20

# 4. Reiniciar sxhkd
pkill sxhkd
sxhkd -c ~/.config/sxhkd/sxhkdrc &

# 5. Verificar logs
sxhkd -c ~/.config/sxhkd/sxhkdrc 2>&1 | head -20
```

### Fuentes no se ven bien

```bash
# 1. Reconstruir cache de fuentes
fc-cache -fv

# 2. Verificar fuentes instaladas
fc-list | grep -i jetbrains

# 3. Si no aparecen:
yay -S ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols

# 4. Reconstruir cache nuevamente
fc-cache -fv

# 5. Reiniciar aplicaciones que usen fuentes
```

### Colores invertidos o extraños

```bash
# 1. Verificar valor de colores en archivos de configuración
grep -r "background" ~/.config/bspwm/

# 2. Resetear tema a predeterminado
bash themes/gruvbox-theme.sh

# 3. Verificar conflictos de tema en Polybar
grep -n "#" ~/.config/polybar/config.ini | head -20
```

### Ventanas se cierran inesperadamente

```bash
# 1. Verificar logs de BSPWM
cat ~/.xsession-errors

# 2. Verificar logs del sistema
journalctl -b | grep bspwm

# 3. Verificar si hay reglas que cierren ventanas
cat ~/.config/bspwm/bspwmrc | grep "rule"

# 4. Desactivar reglas problemáticas
```

---

## 🔍 Debugging Avanzado

### Ver logs en tiempo real

```bash
# Logs de BSPWM
cat ~/.xsession-errors

# Logs del sistema
journalctl -f

# Logs de una aplicación específica
kitty --debug-font-fallback 2>&1 | tee kitty.log
```

### Modo de depuración de BSPWM

```bash
# Inicia BSPWM con debug
DEBUG=1 bspwm 2>&1 | tee bspwm-debug.log

# Ver todos los eventos
bspc subscribe all | head -50
```

### Rastrear variables de entorno

```bash
# Ver variables de entorno
env | sort

# Variables específicas de X11
echo "Display: $DISPLAY"
echo "Path: $PATH"
```

### Crear reportes de error

```bash
# Crear reporte completo
{
    echo "=== Sistema ==="
    uname -a
    echo "\n=== Arch Linux ==="
    cat /etc/os-release
    echo "\n=== Paquetes ==="
    pacman -Q | grep -E "bspwm|sxhkd|polybar"
    echo "\n=== Logs ==="
    tail -30 ~/.xsession-errors
} > bspwm-report.txt

cat bspwm-report.txt
```

---

## 💡 Tips para Evitar Problemas

1. **Hacer backup de configuración**
   ```bash
   tar -czf bspwm-backup-$(date +%Y%m%d).tar.gz ~/.config/{bspwm,sxhkd,polybar}
   ```

2. **Usar versionado de dotfiles**
   ```bash
   cd ~/.config
   git init
   git add -A
   git commit -m "Initial BSPWM config"
   ```

3. **Mantener logs limpios**
   ```bash
   rm ~/.xsession-errors
   ```

4. **Actualizar regularmente**
   ```bash
   sudo pacman -Syu
   yay -Syu
   ```

5. **Documentar cambios**
   ```bash
   echo "Cambié el color de Polybar a $(date)" >> ~/.config/polybar/CHANGES.txt
   ```

---

## 📞 Obtener Ayuda

- **Arch Linux Wiki**: https://wiki.archlinux.org
- **BSPWM GitHub**: https://github.com/baskerville/bspwm
- **Comunidad de Reddit**: r/archlinux
- **Foros**: https://bbs.archlinux.org
- **IRC**: #archlinux en freenode

---

**¡No te desanimes! Casi todo tiene solución 🚀**
