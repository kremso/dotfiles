OS: Ubuntu 17.10<br>
Monospace Font: [Fira Mono](https://github.com/mozilla/Fira)<br>
GTK Theme: [Adapta](http://www.omgubuntu.co.uk/2016/10/install-adapta-gtk-theme-on-ubuntu)<br>
Shell: fish<br>
Browser: Firefox<br>
Email: Mailspring<br>
Editor: nvim<br>
Other tools: tmux, Slack, Postman<b>


- Firefox >57 supports U2F, go to `about:config` and set `security.webauth.u2f=true`
- Get rid of window titles - install [Pixel Saver](https://extensions.gnome.org/extension/723/pixel-saver/)
- Install `gnome-tweak-tool`, Typing > Caps Lock as Ctrl

````
apt install git
git clone $this ~/.dotfiles
cd .dotfiles
./setup.sh
````

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

