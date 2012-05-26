#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#
# set env variables
export BROWSER=firefox
export DE=gnome

xrdb -merge ~/.Xdefaults

# start default apps
urxvtd -q -o -f
xhost +local:0 > /dev/null &
xsetroot -cursor_name left_ptr &
xmodmap ~/.xmodmap &
xbindkeys &
syndaemon -t -i 2 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --tint 0x000000 --height 1 &
xcompmgr -c -r 3 -l -5 -t -5 &
xscreensaver -nosplash &
offlineimap &

# D-Bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
    # save DBUS information to a script that can be used in cron
    touch $HOME/.Xdbus
    chmod 600 $HOME/.Xdbus
    env | grep DBUS_SESSION_BUS_ADDRESS > $HOME/.Xdbus
    echo 'export DBUS_SESSION_BUS_ADDRESS' >> $HOME/.Xdbus
fi

pulseaudio --start
thunar --daemon &

exec xmonad
