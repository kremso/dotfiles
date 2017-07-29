Monospace Font: Fira Mono
GTK Theme: Adapta http://www.omgubuntu.co.uk/2016/10/install-adapta-gtk-theme-on-ubuntu
Other: Client-side decorations http://www.omgubuntu.co.uk/2017/02/how-to-enable-nautilus-csd-header-bar-ubuntu


````
apt install git
git clone $this ~/.dotfiles
cd .dotfiles
./setup.sh
````

sanity
````
apt install gnome-tweak-tool
````
Typing > Caps Lock as Ctrl
Download "Fira Mono" -> set as default monospace font

vim

````
cd ~
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.local/share/dein
````

terminal

````
apt instal fish tmux
chsh -s $(which fish)
````

Terminal > Profile > Command: `tmux new-session -A -s main`
Terminal > Profile > Color scheme: Solarized Dark

