OS: Ubuntu 17.10<br>
Monospace Font: [Fira Mono](https://github.com/mozilla/Fira)<br>
GTK Theme: [Adapta](http://www.omgubuntu.co.uk/2016/10/install-adapta-gtk-theme-on-ubuntu)<br>
Shell: fish<br>
Browser: Firefox<br>
Email: Mailspring<br>
Editor: nvim<br>
Other tools: tmux, Slack, Postman<br>


- Firefox >57 supports U2F, go to `about:config` and set `security.webauth.u2f=true`
- Get rid of window titles - install [No Title Bar](https://extensions.gnome.org/extension/1267/no-title-bar/)
- Caps Lock as Ctrl - `dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"`

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

yubikey

    sudo apt install -y gnupg2 gnupg-agent pinentry-curses scdaemon pcscd yubikey-personalization libusb-1.0-0-dev

```
$ cat << EOF > ~/.gnupg/gpg.conf
auto-key-locate keyserver
keyserver hkps://hkps.pool.sks-keyservers.net
keyserver-options no-honor-keyserver-url
keyserver-options ca-cert-file=/etc/sks-keyservers.netCA.pem
keyserver-options no-honor-keyserver-url
keyserver-options debug
keyserver-options verbose
personal-cipher-preferences AES256 AES192 AES CAST5
personal-digest-preferences SHA512 SHA384 SHA256 SHA224
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-cipher-algo AES256
s2k-digest-algo SHA512
charset utf-8
fixed-list-mode
no-comments
no-emit-version
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
use-agent
require-cross-certification
EOF
```

```
$ cat << EOF > ~/.gnupg/gpg-agent.conf
enable-ssh-support
pinentry-program /usr/bin/pinentry-curses
default-cache-ttl 60
max-cache-ttl 120
write-env-file
use-standard-socket
EOF
```
