#!/bin/bash

HOSTNAME=$(hostname)
if [ "$HOSTNAME" = "maven-dL01" ]; then
	#xrandr --output DisplayPort-5 --left-of DisplayPort-4
	#xrandr --output DisplayPort-4 --left-of DisplayPort-6
	if xrandr | grep "HDMI-A-1 connected"; then
		xrandr --output HDMI-A-1 --left-of DisplayPort-5 --scale 1x1 \
			--output DisplayPort-5 --left-of DisplayPort-4 --scale 1x1 \
			--output DisplayPort-4 --primary --scale 1x1 \
			--output DisplayPort-6 --right-of DisplayPort-4 --scale 1x1
	else
		xrandr --output DisplayPort-5 --left-of DisplayPort-4 --scale 1x1 \
			--output DisplayPort-4 --primary --scale 1x1 \
			--output DisplayPort-6 --right-of DisplayPort-4 --scale 1x1
	fi

	compton -CG &

	DISPLAY=:0 feh --bg-fill ~/.dotfiles/wallpapers/solarized_minimal.jpg
	DISPLAY=:1 feh --bg-fill ~/.dotfiles/wallpapers/solarized_minimal.jpg
	DISPLAY=:2 feh --bg-fill ~/.dotfiles/wallpapers/solarized_minimal.jpg
	DISPLAY=:3 feh --bg-fill ~/.dotfiles/wallpapers/solarized_minimal.jpg
fi
