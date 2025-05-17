#!/bin/bash

reset

readonly NeovimPathes=("$XDG_CONFIG_HOME/nvim" "$HOME/.local/share/nvim")

RED='\033[0;31m'
GREEN='\033[0;92m'
NC='\033[0m' # No Color

shopt -s expand_aliases

dependencies=(build-essential gdb wget shellcheck shfmt pkg-config lsb-release software-properties-common gnupg libfontconfig-dev libreadline-dev unzip lua5.4 liblua5.4-dev ninja-build ripgrep)

readonly steps=18

PrintInstallStatus() {
	printf "[$((((100 / $steps) * $1)))%%] ${GREEN}$2${NC}\n"
}

main() {
	init
	if [ $? -eq 0 ]; then
		PrintInstallStatus 1 "Initialized."
	else
		printf "Error"
		exit
	fi
	UninstallNeovim
	if [ $? -eq 0 ]; then
		PrintInstallStatus 3 "Uninstalled Neovim from your system."
	else
		printf "Error"
		exit
	fi
	InstallDependencies
	if [ $? -eq 0 ]; then
		PrintInstallStatus 4 "Installed dependencies."
	else
		printf "Error"
		exit
	fi
	InstallNodeJS
	if [ $? -eq 0 ]; then
		PrintInstallStatus 5 "Installed Node.js."
	else
		printf "Error"
		exit
	fi
	InstallBashLanguageServer
	if [ $? -eq 0 ]; then
		PrintInstallStatus 6 "Installed language server for bash script."
	else
		printf "Error"
		exit
	fi
	InstallNeovim
	if [ $? -eq 0 ]; then
		PrintInstallStatus 7 "Installed Neovim."
	else
		printf "Error"
		exit
	fi
	InstallCargo
	if [ $? -eq 0 ]; then
		PrintInstallStatus 8 "Installed Cargo."
	else
		printf "Error"
		exit
	fi
	InstallAlacritty
	if [ $? -eq 0 ]; then
		PrintInstallStatus 9 "Installed Alacritty."
	else
		printf "Error"
		exit
	fi
	InstallStyLua
	if [ $? -eq 0 ]; then
		PrintInstallStatus 10 "Installed StyLua."
	else
		printf "Error"
		exit
	fi
	InitNeovimConfigs
	if [ $? -eq 0 ]; then
		PrintInstallStatus 12 "Initialized Neovim's configs."
	else
		printf "Error"
		exit
	fi
	InstallFont
	if [ $? -eq 0 ]; then
		PrintInstallStatus 13 "Installed required font."
	else
		printf "Error"
		exit
	fi
	InitAlacrittyConfigs
	if [ $? -eq 0 ]; then
		PrintInstallStatus 14 "Initialized Alacritty's configs."
	else
		printf "Error"
		exit
	fi
	InstallLLVM
	if [ $? -eq 0 ]; then
		PrintInstallStatus 15 "Installed LLVM on Your System."
	else
		printf "Error"
		exit
	fi
	ConfigureAlacritty
	if [ $? -eq 0 ]; then
		PrintInstallStatus 16 "Configured Alacritty."
	else
		printf "Error"
		exit
	fi
	InstallXmake
	if [ $? -eq 0 ]; then
		PrintInstallStatus 17 "Installed XMake."
	else
		printf "Error"
		exit
	fi
	InstallLuaLS
	if [ $? -eq 0 ]; then
		PrintInstallStatus 18 "Installed LuaLS."
	else
		printf "Error"
		exit
	fi
	test
}

OSIsLinuxGNU() {
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		return 1
	else
		return 0
	fi
}

init() {
	if OSIsLinuxGNU 1; then
		sudo apt update && sudo apt upgrade -y
	fi
}

InstallDependencies() {
	if OSIsLinuxGNU 1; then
		for i in ${dependencies[@]}; do
			sudo apt install -y $i >/dev/null
		done
	fi
}

InstallNodeJS() {
	if OSIsLinuxGNU 1; then
		if ! command -v npm >/dev/null 2>&1; then
			# Download and install fnm:
			(curl -o- https://fnm.vercel.app/install | bash) >/dev/null

			# Download and install Node.js:
			fnm install 22 >/dev/null

			source $HOME/.bashrc >/dev/null

			rm -rf 1
		fi
	fi
}

InstallBashLanguageServer() {
	npm i -g bash-language-server >/dev/null
}

InstallNeovim() {
	if OSIsLinuxGNU 1; then
		if ! command -v nvim >/dev/null 2>&1; then
			curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz >/dev/null
			sudo rm -rf /opt/nvim
			sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz >/dev/null
			echo export PATH="$PATH:/opt/nvim-linux-x86_64/bin" >>$HOME/.bashrc

			rm -rf 1
		fi
	fi
}

InstallCargo() {
	if OSIsLinuxGNU 1; then
		if ! command -v cargo >/dev/null 2>&1; then
			(curl https://sh.rustup.rs -sSf | sh -s -- -y) >/dev/null
			. "$HOME/.cargo/env"

			rm -rf 1
		fi
	fi
}

InstallAlacritty() {
	if OSIsLinuxGNU 1; then
		if ! command -v alacritty >/dev/null 2>&1; then
			cargo install alacritty >/dev/null

			rm -rf 1
		fi
	fi
}

InstallStyLua() {
	if OSIsLinuxGNU 1; then
		if ! command -v stylua >/dev/null 2>&1; then
			cargo install stylua >/dev/null

			rm -rf 1
		fi
	fi
}

UninstallNeovim() {
	if OSIsLinuxGNU 1; then
		for i in ${NeovimPathes[@]}; do
			rm -rf $i
		done
	fi
}

InitNeovimConfigs() {
	cp -r .config/nvim ${NeovimPathes[0]}
}

InstallFont() {
	fc-list : family style | sort | uniq | grep "JetBrainsMonoNL Nerd Font Mono,JetBrainsMonoNL NFM:style=Regular" >/dev/null 2>&1

	if [[ $? != 0 ]]; then
		if [ ! -d $HOME/.fonts/ ]; then
			mkdir $HOME/.fonts/
		fi
		if [ ! -d $HOME/.fonts/JetBrainsMonoNerdFont/ ]; then
			mkdir $HOME/.fonts/JetBrainsMonoNerdFont/
		fi
		cp -r .fonts/JetBrainsMonoNerdFont/ $HOME/.fonts/
	fi
}

InitAlacrittyConfigs() {
	if [ ! -e $HOME/.alacritty.toml ]; then
		cp .alacritty.toml $HOME
	fi
}

InstallLLVM() {
	if ! command -v clangd-21 >/dev/null 2>&1; then
		wget https://apt.llvm.org/llvm.sh >/dev/null
		chmod +x llvm.sh
		sudo ./llvm.sh 21 >/dev/null

		rm -rf 1
	fi
	sudo apt install clang-format-21 >/dev/null
}

ConfigureAlacritty() {
	echo alias alacritty="env WAYLAND_DISPLAY= alacritty" >>"$HOME/.bashrc"
	source "$HOME/.bashrc"
}

InstallXmake() {
	curl -fsSL https://xmake.io/shget.text | bash
}

InstallLuaLS() {
	if ! command -v lua-language-server >/dev/null 2>&1; then
		git clone https://github.com/LuaLS/lua-language-server >/dev/null
		cd lua-language-server && ./make.sh >/dev/null && sudo make install >/dev/null && cd .. && rm -rf lua-language-server
		mv lua-language-server $HOME/.local/share/ && ln -s $HOME/.local/share/lua-language-server/bin/lua-language-server $HOME/.local/bin/lua-language-server
		export PATH=$PATH:$HOME/.local/bin
	fi
}

test() {
	alacritty -e nvim
}

main

reset
