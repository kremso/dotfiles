(xbindkey '("XF86AudioRaiseVolume") "amixer set Master 5%+")
(xbindkey '("XF86AudioLowerVolume") "amixer set Master 5%-")
(xbindkey '("XF86AudioMute") "amixer set Master 0%")
(xbindkey '("XF86MonBrightnessDown") "~/dotfiles/bin/screen_control.sh down")
(xbindkey '("XF86MonBrightnessUp") "~/dotfiles/bin/screen_control.sh up")
(xbindkey '("XF86Sleep") "sudo pm-suspend")

