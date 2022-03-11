#!/bin/bash

set -e

HELP_STR="Usage: ./setup.bash [--i3 | --i3-gaps] | --help"

music_stuff=false
operating_system='none'
window_manager='none'

# parse command line args
for i in "$@"
do
	case $i in
	--i3-gaps)
	
		window_manager='i3-gaps'
		;;
        --i3)
		window_manager='i3'
		;;
	--music)
		music_stuff=true
		;;
	-h|--help)
		echo -e "\n$HELP_STR"
		exit 0
		;;
	*)
 		echo "Unrecognized Option: $i"
		echo -e "\n$HELP_STR"
		exit 1
		# unknown options
		;;
    esac
done

# Become root
if [ $UID -ne 0 ]; then
	echo "-- Becoming root"
	exec sudo $0 $@
fi

# This script is run as sudo, but we dont want config files
# to be owned by root. We can use this to fix ownership
SETUP_USER="$SUDO_USER"
if [ -z "$SETUP_USER" ]; then
	SETUP_USER="$(whoami)"
fi

#detect os
echo "Detecting operating system."
if grep -q "Ubuntu 20.04" /etc/lsb-release; then
	echo "Ubuntu 20.04 LTS detected!"
	operating_system='ubuntu-20.04'
else
	echo "Unsupported operating system detected."
	exit 1
fi

mkdir -p build

#############
#  Packages #
#############

PKGS_FILE="system_packages/$operating_system-packages.txt"
PACKAGES="$(sed 's/#.*//;/^$/d' ${PKGS_FILE})"
if [ "$operating_system" = "ubuntu-20.04" ]; then
	apt update
	apt install -y $PACKAGES
fi


#############
#  WM Setup #
#############

if [ "$window_manager" = "i3-gaps" ]; then
	pushd window_manager/i3-gaps
	./setup.bash
	popd
elif [ "$window_manager" = "i3" ]; then
	pushd window_manager/i3
	./setup.bash
	popd
fi

################
#  Shell Setup #
################

# check if .oh-my-zsh is installed
if [ -d "/home/$SETUP_USER/.oh-my-zsh" ]; then
	set +e

	git --git-dir=/home/$SETUP_USER/.oh-my-zsh status > /dev/null
	if [ $? -ne 0 ]; then
		echo "Oh-My-Zsh exists but the repo is in an invalid state."
		echo "Will not clone."
	else
		echo "Oh-My-Zsh found."
	fi

	set -e
else
	echo "No Oh-My-Zsh folder was found. Will run RR inst."

	echo "Installing oh-my-zsh..."
	pushd build

	if [ ! -d oh-my-zsh ]; then
		mkdir oh-my-zsh
	fi
	pushd oh-my-zsh

	if [ -f install.sh ]; then 
		rm install.sh
	fi
	wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	chmod 555 install.sh

	# install for root
	if [ ! -d /root/.oh-my-zsh ]; then
		echo "Installing ZSH for root"
		./install.sh --unattended
	fi

	# install for user
	if [ ! -d /home/$SETUP_USER/.oh-my-zsh ]; then
		echo "Installing ZSH for $SETUP_USER"
		su $SETUP_USER -c "./install.sh --unattended --keep-zshrc"
	fi

	popd
	popd

	echo "Installing powerlevel9k extensions..."
	git clone https://github.com/bhilburn/powerlevel9k.git /home/$SETUP_USER/.oh-my-zsh/custom/themes/powerlevel9k

	echo "Fixing permissions..."
	chown -R $SETUP_USER:$SETUP_USER /home/$SETUP_USER/.oh-my-zsh

	if [ -f /home/$SETUP_USER/.oh-my-zsh ]; then
		chown $SETUP_USER:$SETUP_USER /home/$SETUP_USER/.zshrc
	fi

	if [ -f /home/$SETUP_USER/.zsh_history ]; then
		chown $SETUP_USER:$SETUP_USER /home/$SETUP_USER/.zsh_history
	fi

	# restore zshrc
	if [ -f /home/$SETUP_USER/.zshrc.pre-oh-my-zsh ]; then
		mv /home/$SETUP_USER/.zshrc.pre-oh-my-zsh /home/$SETUP_USER/.zshrc
	fi

	pushd build

	# build powerline
	echo "Will perform one time install of powerline fonts."
	if [ ! -f fonts ]; then
		git clone https://github.com/powerline/fonts.git --depth=1
	fi

	pushd fonts
	./install.sh
	su $SETUP_USER -c ./install.sh
	popd
	#rm -rf fonts

	# build nerd fonts
	echo "Will perform one time install of nerd font glyphs."
	if [ ! -f nerd-fonts ]; then
		git clone https://github.com/ryanoasis/nerd-fonts.git --depth=1
	fi

	pushd nerd-fonts
	./install.sh
	su $SETUP_USER -c ./install.sh
	popd
	#rm -rf nerd-fonts

	popd # build/

	echo "Updating shell..."
	chsh -s /usr/bin/zsh $SETUP_USER

	echo "Installed Oh-My-Zsh"
fi

###########
#  Snaps  #
###########

if echo "$operating_system" | grep -i "ubuntu"; then
	echo "Will install snaps..."
	SNAPS_FILE="system_packages/ubuntu-snaps.txt"
	SNAPS="$(sed 's/#.*//;/^$/d' ${SNAPS_FILE})"
	SNAP_ARR=($SNAPS)
	for snp in "${SNAP_ARR[@]}"; do
		snap install --classic $snp
	done
fi

#################
#  Tizonia/Viz  #
#################

if $music_stuff; then
	pushd build/

	if [ ! -d tizonia-openmax-il ]; then
		git clone https://github.com/tizonia/tizonia-openmax-il.git
	fi

	if [ ! -d cli-visualizer ]; then
		git clone https://github.com/dpayne/cli-visualizer.git
	fi

	export TIZONIA_REPO_DIR=$(pwd)/tizonia-openmax-il
	export TIZONIA_INSTALL_DIR=/usr
	export PATH=$TIZONIA_REPO_DIR/tools:$PATH
	if [ "$operating_system" = "ubuntu-20.04" ]; then
		sudo -H pip3 install meson --upgrade
		apt install -y libfftw3-dev libncursesw5-dev cmake libpulse-dev ninja-build

		if ! command -v tizonia; then
			export PYTHONPATH=$TIZONIA_INSTALL_DIR/lib/python3.8/site-packages:$PYTHONPATH
			
			tizonia-dev-build --deps

			pushd tizonia-openmax-il

			meson --buildtype=plain \
				--prefix=/usr \
				--libdir=/usr/lib \
				--libexecdir=/usr/lib \
				--bindir=/usr/bin \
				--sbindir=/usr/sbin \
				--includedir=/usr/include \
				--datadir=/usr/share \
				--mandir=/usr/share/man \
				--infodir=/usr/share/info \
				--localedir=/usr/share/locale \
				--sysconfdir=/etc \
				--localstatedir=/var \
				--sharedstatedir=/var/lib \
				--wrap-mode=nodownload \
				--auto-features=enabled \
				. build

			ninja -v -j1 -C build
			ninja install -v -j1 -C build

			popd # tizonia
		fi

		if ! command -v vis; then
			pushd cli-visualizer

			mkdir -p build/
			pushd build

			cmake ..
			make clean
			make -j$(nproc) ENABLE_PULSE=1
			make install

			$CFG_DIR=/home/$SETUP_USER/.config/vis
			mkdir -p $CFG_DIR/colors

			cp examples/config $CFG_DIR
			cp examples/rainbow $CFG_DIR/colors
			cp eaxmples/basic_colors $CFG_DIR/colors

			chown -R $SETUP_USER:$SETUP_USER $CFG_DIR

			popd # build
			popd # cli-visualizer
		fi
	fi

	popd # build
fi

################
#  User Setup  #
################

su $SETUP_USER -c ./setup_no_root.bash
