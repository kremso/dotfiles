#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

xhost +local:0 > /dev/null &
xsetroot -cursor_name left_ptr &
xmodmap ~/.xmodmap &
xbindkeys &
syndaemon -t -i 2 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --tint 0x000000 --height 1 &
xcompmgr -c -r 3 -l -5 -t -5 &
feh --bg-scale ~/wallpapers/rotate/cloud_storage.png
xscreensaver -nosplash &
mpc
export BROWSER=chromium
export DE=gnome

#exec ck-launch-session openbox-session
exec ck-launch-session xmonad
# exec gnome-session
# exec startkde
# exec startxfce4
# exec icewm
# exec openbox
# exec blackbox
# exec fluxbox
# exec ratpoison
# exec dwm
# ... or any other WM of your choosing ...
