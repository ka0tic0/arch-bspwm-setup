#!/bin/bash
# Archivo de inicialización de X11 para BSPWM

# Ejecutar los archivos de perfil si existen
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Configuración del teclado
# Cambiar 'es' por tu distribución: us, de, fr, en, etc.
setxkbmap es

# Velocidad de repetición del teclado (opcional)
# xset r rate 200 50

# Iniciar BSPWM
exec bspwm
