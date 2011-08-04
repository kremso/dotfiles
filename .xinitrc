#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#
# set env variables
export BROWSER=firefox
export DE=gnome

# start default apps
urxvtd -q -o -f
xhost +local:0 > /dev/null &
xsetroot -cursor_name left_ptr &
xmodmap ~/.xmodmap &
xbindkeys &
syndaemon -t -i 2 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --tint 0x000000 --height 1 &
xcompmgr -c -r 3 -l -5 -t -5 &
#feh --bg-scale ~/wallpapers/rotate/cloud_storage.png
xscreensaver -nosplash &
autossh -M 2526 -t -t peweproxy.fiit.stuba.sk -L 2525:dcs.fiit.stuba.sk:25 &

# D-Bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

thunar --daemon &

#exec ck-launch-session xmonad
exec xmonad
