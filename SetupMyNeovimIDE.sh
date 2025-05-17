#!/bin/bash

shopt -s expand_aliases

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	sudo apt update && sudo apt upgrade -y && sudo apt install -y build-essential gdb wget shellcheck shfmt pkg-config lsb-release software-properties-common gnupg libfontconfig-dev libreadline-dev unzip lua5.4 liblua5.4-dev ninja-build ripgrep

	if ! command -v npm >/dev/null 2>&1; then
		# Download and install fnm:
		curl -o- https://fnm.vercel.app/install | bash

		# Download and install Node.js:
		fnm install 22

		source $HOME/.bashrc

		rm -rf 1
	fi

	npm i -g bash-language-server

	if ! command -v nvim >/dev/null 2>&1; then
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
		sudo rm -rf /opt/nvim
		sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
		echo export PATH="$PATH:/opt/nvim-linux-x86_64/bin" >>$HOME/.bashrc

		rm -rf 1
	fi

	if ! command -v cargo >/dev/null 2>&1; then
		curl https://sh.rustup.rs -sSf | sh -s -- -y
		. "$HOME/.cargo/env"

		rm -rf 1
	fi

	if ! command -v alacritty >/dev/null 2>&1; then
		cargo install alacritty

		rm -rf 1
	fi

	if ! command -v stylua >/dev/null 2>&1; then
		cargo install stylua

		rm -rf 1
	fi

	if [ -d "$XDG_CONFIG_HOME/nvim/" ]; then
		rm -rf $XDG_CONFIG_HOME/nvim
	fi

	mkdir $XDG_CONFIG_HOME/nvim/
	cp -r .config/nvim/* $XDG_CONFIG_HOME/nvim/

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

	if [ ! -e $HOME/.alacritty.toml ]; then
		cp .alacritty.toml $HOME
	fi

	if ! command -v clangd-21 >/dev/null 2>&1; then
		wget https://apt.llvm.org/llvm.sh
		chmod +x llvm.sh
		sudo ./llvm.sh 21

		rm -rf 1
	fi

	sudo apt install clang-format-21

	echo alias alacritty="env WAYLAND_DISPLAY= alacritty" >>$HOME/.bashrc
	source ~/.bashrc

	curl -fsSL https://xmake.io/shget.text | bash

	alacritty -e nvim

	if ! command -v lua-language-server >/dev/null 2>&1; then
		git clone https://github.com/LuaLS/lua-language-server
		cd lua-language-server && ./make.sh && sudo make install && cd .. && rm -rf lua-language-server
		mv lua-language-server $HOME/.local/share/ && ln -s $HOME/.local/share/lua-language-server/bin/lua-language-server $HOME/.local/bin/lua-language-server
		export PATH=$PATH:$HOME/.local/bin
	fi
fi
