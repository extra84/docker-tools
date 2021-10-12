#!/bin/bash
#export CARGO_HOME=/workspace/cargo
#export RUSTUP_HOME=/workspace/rustup
echo "user : $(whoami)"
OLDPATH=$PATH
CURDIR=$(pwd)
GID=$(stat --format=%g /workspace)

for folder in {cargo,rustup,projects}; do
	if [ ! -d /workspace/$folder ]; then
		echo Creating folder $folder
        	/usr/sbin/gosu rust:$GID mkdir /workspace/$folder
	fi
done
if [[ -d "/workspace/init" ]]; then
	echo "Init folder found. Running available scripts"
	echo $(ls /workspace/init)
	run-parts /workspace/init
else
	echo "No Init folder found. Skipping"
fi
cd $CURDIR
echo "Current user is $(whoami)"
echo "Current gid is $GID"
echo "Setting mask"
umask 002
if [[ ! -e "/home/rust/.vim/autoload/plug.vim" ]]; then
	/usr/sbin/gosu rust:$GID curl -sSfLo /home/rust/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if [[ -d "/workspace/cargo" ]]; then
        echo "cargo already installed. skipping"
else
        echo "cargo not found"
	/usr/sbin/gosu rust:$GID curl https://sh.rustup.rs -sSfLo /home/rust/rust.sh  \
		&& /usr/sbin/gosu rust:$GID bash /home/rust/rust.sh -y
fi
export PATH=$PATH:$CARGO_HOME/bin:$RUSTUP_HOME/bin
echo "Initialisation complete. Now Ladies & Gentlemen please enjoy your rust programming session"
exec /usr/sbin/gosu rust bash

