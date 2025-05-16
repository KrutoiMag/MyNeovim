#!/bin/bash

shopt -s expand_aliases

if [[ "$OSTYPE" == "linux-gnu" ]]; then
	sudo apt update && sudo apt upgrade && sudo apt install build-essential gdb wget shellcheck shfmt

	# Download and install fnm:
	curl -o- https://fnm.vercel.app/install | bash

	# Download and install Node.js:
	fnm install 22

	# Verify the Node.js version:
	node -v # Should print "v22.15.1".

	# Verify npm version:
	npm -v # Should print "10.9.2".

	npm i -g bash-language-server

	if ! command -v nvim 2>&1 >/dev/null; then
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
		sudo rm -rf /opt/nvim
		sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	fi

	if ! command -v cargo 2>&1 >/dev/null; then
		curl https://sh.rustup.rs -sSf | sh -s -- -y
		if ! command -v alacritty 2>&1 >/dev/null; then
			cargo install alacritty
		fi
	fi

	if [ -d "$XDG_CONFIG_HOME/nvim/" ]; then
		rm -rf $XDG_CONFIG_HOME/nvim
	fi

	mkdir $XDG_CONFIG_HOME/nvim/
	cp -r .config/nvim/* $XDG_CONFIG_HOME/nvim/

	fc-list : family style | sort | uniq | grep "JetBrainsMonoNL Nerd Font Mono,JetBrainsMonoNL NFM:style=Regular" 2>&1 >/dev/null

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

	if ! command -v clangd-21 2 &>1 >/dev/null; then
		wget https://apt.llvm.org/llvm.sh
		chmod +x llvm.sh
		sudo ./llvm.sh 21
	fi

	cmd=alias alacritty="env WAYLAND_DISPLAY= alacritty"

	if ! grep -Fxq $cmd $HOME/.bashrc; then
		echo $cmd >>$HOME/.bashrc
		source ~/.bashrc
	fi

	alacritty -e nvim
fi
