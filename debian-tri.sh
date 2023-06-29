#!/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

### Installing softwares
sudo nala install build-essential procps curl file wget git gimp krita inkscape thunderbird htop stacer okular calibre flameshot lutris kazam kadenlive gnome-software redshift discover clamav clamtk synaptic qt5-style-kvantum python3.10-venv ueberzug luarocks xclip qbittorrent gpm ibus-avro neofetch gdebi ranger knotes fzf redshift-gtk exa clang-format reuse kwin-bismuth fortune cowsay figlet lolcat tty-clock cmatrix alacritty cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 hexyl bat chafa tmux tldr-y --install-suggests

# Install brave-browser
sudo nala install apt-transport-https curl -y --install-suggests
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo nala update
sudo nala install brave-browser -y --install-suggests

# Install spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo nala update && sudo nala install spotify-client -y --install-suggests

# Install fsearch
echo 'deb http://download.opensuse.org/repositories/home:/cboxdoerfer/Debian_Testing/ /' | sudo tee /etc/apt/sources.list.d/home:cboxdoerfer.list
curl -fsSL https://download.opensuse.org/repositories/home:cboxdoerfer/Debian_Testing/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_cboxdoerfer.gpg > /dev/null
sudo nala update
sudo nala install fsearch -y --install-suggests
## For ubuntu
#sudo add-apt-repository ppa:christian-boxdoerfer/fsearch-stable
#sudo nala update
#sudo nala install fsearch -y

# vscode
sudo nala install wget gpg -y --install-suggests
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
## Install code
sudo nala install apt-transport-https -y --install-suggests
sudo nala update
sudo nala install code -y --install-suggests  # or code-insiders

## Install steam
sudo dpkg --add-architecture i386 ### add 32 bit architecture
sudo nala update
sudo add-apt-repository non-free
sudo nala install software-properties-common -y --install-suggests
sudo nala update
sudo nala install steam -y --install-suggests

## Install protonvpn
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3_all.deb
sudo dpkg --install protonvpn*
sudo nala update
sudo nala install protonvpn easy-rsa openvpn-dco-dkms openvpn-systemd-resolved
rm protonvpn*

# onlyoffice
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /etc/apt/trusted.gpg.d/
##
echo 'deb https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list
sudo nala update
sudo nala install onlyoffice-desktopeditors

# rambox
sudo snap install rambox

# protonup-qt
flatpak install net.davidotek.pupgui2

# install app-outlet
# wget https://github.com/app-outlet/app-outlet/releases/download/v2.1.0/app-outlet_2.1.0_amd64.deb
# sudo dpkg --install app-outlet*
# rm -rf app-outlet*

# pacstall
sudo bash -c "$(curl -fsSL https://git.io/JsADh || wget -q https://git.io/JsADh -O -)"

# Enables Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## configure
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

# Installes Neovim
sudo nala install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen gdu gcc ripgrep cargo npm -y --install-suggests
pip install cmake matplotlib numpy vpython
cd $builddir
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
git checkout stable
sudo make install
cd ..
sudo rm -rf neovim
## neovim configuration
brew install lazygit bottom pipes-sh lesspipe gitmoji ripgrep
cargo install tree-sitter-cli
## Configuration
cd $builddir
git clone https://github.com/msbiy/NvBas.git
## Astronvim
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
mkdir /home/$username/.config/nvim/lua/user/
cp -r NvBas/astro.lua  /home/$username/.config/nvim/lua/user/
nvim  --headless -c 'autocmd User PackerComplete quitall'
## Lunarvim
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
cp -r NvBas/lunar.lua .config/lvim/config.lua
cp -r Nvbas/lunarboard.lua .local/share/lunarvim/lvim/lua/lvim/core/alpha/dashboard.lua

rm -rf NvBas

## ble.sh
git clone --recursive https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make
make install
cd ..
## autojump
git clone git://github.com/wting/autojump.git
cd autojump
./install.py
cd ..
rm -rf ble.sh autojump*
## configuration
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
cp -r bashrc /home/$username/.bashrc # bashrc

# ZSH
cd $builddir
## Install Oh-My-ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
## Install Zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
## Configuration
cp -r zshrc /home/$username/.zshrc
# vi-mode
git clone https://github.com/jeffreytse/zsh-vi-mode \
  $ZSH_CUSTOM/plugins/zsh-vi-mode
# fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

# Installing fonts
cd $builddir
mkdir -p /home/$username/.fonts
chown -R $username:$username /home/$username

nala install fonts-font-awesome
wget https://use.fontawesome.com/releases/v6.2.1/fontawesome-free-6.2.1-desktop.zip
unzip unzip fontawesome*.zip
cp -r fontawesome*/otfs/*.otf ~/.fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/FiraCode.zipp
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
wget -O Roboto.zip https://fonts.google.com/download?family=Roboto
unzip Roboto.zip -d /home/$username/.fonts
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf

# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip ./Roboto.zip ./Fontawesome*

# ranger plugin
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf

# Alacritty configuration
cd $builddir
cp -r Alacritty $HOME/.config/alacritty

# DT colorscript
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
# Removal
sudo make uninstall
# optional for zsh completion
sudo cp completions/_colorscript /usr/share/zsh/site-functions
# optional for fish shell completion
sudo cp completions/colorscript.fish /usr/share/fish/vendor_completions.d

# installation finish message
echo "configuration successfully finished" 2>&1

## reboot
reboot



