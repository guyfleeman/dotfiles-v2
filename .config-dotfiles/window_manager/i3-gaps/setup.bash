#!/bin/bash

echo "Prompting for root..."
# Become root
if [ $UID -ne 0 ]; then
	echo "-- Becoming root"
	exec sudo $0 $@
fi

BASE=$(readlink -f $(dirname $0))

system='none'
if grep -q "Ubuntu 20.04" /etc/lsb-release; then
	echo "Detected Ubuntu 20.04"
	system="ubuntu-20.04"
fi

if [ "$system" = "ubuntu-20.04" ]; then
	apt remove --purge i3

	i3_wm_ppa="ppa:regolith-linux/stable"
	if ! grep -q "^deb .*$i3_wm_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
		echo "i3-gaps ppa not found, adding..."
		add-apt-repository -y ppa:regolith-linux/stable
	fi

	PACKAGE_LIST="./ubuntu-20.04-packages.txt"
else
	echo "OS version unsupported for i3-gaps."
	exit 1
fi

# install all the i3 packages
echo "Installing packages..."
PACKAGES="$(sed 's/#.*//;/^$/d' $PACKAGE_LIST)"
apt update
apt install -y $PACKAGES

# get the non-root user to fix config file perms
SETUP_USER="$SUDO_USER"
if [ -z "$SETUP_USER" ]; then
	SETUP_USER="$(whoami)"
fi

# link the correct config file
CONFIG_DIR="/home/$SETUP_USER/.config/i3"
mkdir -p $CONFIG_DIR

if [ -f "$CONFIG_DIR/config" ]; then
	echo "Found existing config. Removing..."
	rm $CONFIG_DIR/config
fi

echo "Linking the config file..."
ln -s $BASE/config $CONFIG_DIR/config

# fix perms since root setup this up
echo "Fixing permissions..."
chown -R $SETUP_USER:$SETUP_USER $CONFIG_DIR

# exit
echo "i3 gaps setup complete"
exit 0
