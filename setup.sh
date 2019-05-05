#!/bin/bash

echo "=== Insert Yubikey and press Enter"
read

echo "=== Updating system"
sudo apt update
sudo apt upgrade

echo "=== Installing Yubikey dependencies"
sudo apt install -y gnupg2 gnupg-agent pinentry-curses scdaemon pcscd yubikey-personalization libusb-1.0-0-dev

echo "=== Writing GPG config"
cat << EOF > ~/.gnupg/gpg.conf
auto-key-locate keyserver
keyserver hkps://hkps.pool.sks-keyservers.net
keyserver-options no-honor-keyserver-url
keyserver-options no-honor-keyserver-url
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

cat << EOF > ~/.gnupg/gpg-agent.conf
enable-ssh-support
pinentry-program /usr/bin/pinentry-gnome3
default-cache-ttl 60
max-cache-ttl 120
EOF

echo "=== Restarting gpg-agent"
gpg-agent restart

echo "=== Importing public key"
gpg --recv 0xBED99816BC066E8A

echo "=== Type 'trust' and then select option 5 (ultimate trust) and then type 'save'"
gpg --edit-key 0xBED99816BC066E8A

echo "=== Mapping caps-lock to control"
dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"

echo "=== Installing tools"
sudo apt install git neovim curl fzf ripgrep fish tmux autocutsel

echo "=== Changing default shell to fish"
chsh -s $(which fish)

echo "=== Installing vim/dein"
cd ~
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh ~/.local/share/dein

echo "=== Installing fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "=== Cloning dotfiles"
git clone https://github.com/kremso/dotfiles.git ~/.dotfiles

echo "=== Updating submodules"
cd ~/.dotfiles
git submodule init
git submodule update

echo "=== Installing rcm"
sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm
sudo apt-get update
sudo apt-get install rcm

echo "=== Linking dotfiles"
cd ~/.dotfiles
rcup
