#!/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

### Installing softwares
sudo nala install build-essential procps curl file wget git gimp krita inkscape thunderbird htop stacer okular calibre flameshot lutris kazam kadenlive gnome-software redshift app-outlet gnome-software discover clamav clamtk app-outlet synaptic qt5-style-kvantum python3.10-venv ueberzug luarocks xclip qbittorrent -y --install-suggests

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

# rambox
sudo snap install rambox

# onlyoffice
flatpak install onlyoffice

# install app-outlet
# wget https://github.com/app-outlet/app-outlet/releases/download/v2.1.0/app-outlet_2.1.0_amd64.deb
# sudo dpkg --install app-outlet*
# rm -rf app-outlet*

# Enables Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## configure
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile

# Installes Neovim
sudo nala install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen -y --install-suggests
pip install cmake
cd $builddir
git clone https://github.com/neovim/neovim
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
git checkout stable
sudo make install
cd ..
sudo rm -rf neovim
## neovim configuration
sudo nala install gdu gcc ripgrep -y
brew install lazygit bottom
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
# mybash
git clone https://github.com/ChrisTitusTech/mybash.git
cd mybash
./setup.sh
cd ..
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
# configuration
cp -r bashrc /home/$username/.bashrc # bashrc

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

echo "configuration successfully finished" 2>&1

## reboot
reboot



