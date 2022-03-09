#!/bin/bash

HOSTNAME=$(hostname)
if [ "$HOSTNAME" = "maven-dL01" ]; then
	#xrandr --output DisplayPort-5 --left-of DisplayPort-4
	#xrandr --output DisplayPort-4 --left-of DisplayPort-6
	if xrandr | grep "HDMI-A-1 connected"; then
		#xrandr --output HDMI-A-1 --left-of DisplayPort-5 --scale 1x1 \
		#	--output DisplayPort-5 --left-of DisplayPort-4 --scale 1x1 \
		#	--output DisplayPort-4 --primary --scale 1x1 \
		#	--output DisplayPort-6 --right-of DisplayPort-4 --scale 1x1

		xrandr --dpi 228 \
			--output HDMI-A-1 --pos 0x0 --mode 3840x2160 --scale 1x1 \
                	--output DisplayPort-5 --pos 3840x0 --mode 1920x1080 --scale 2x2 \
                	--output DisplayPort-4 --pos 7680x0 --mode 2560x1440 --scale 1.5x1.5 --primary \
                	--output DisplayPort-6 --pos 11520x0 --mode 1920x1080 --scale 2x2
	else
		xrandr --dpi 228 \
                	--output DisplayPort-5 --pos 3840x0 --mode 1920x1080 --scale 2x2 \
                	--output DisplayPort-4 --pos 7680x0 --mode 2560x1440 --scale 1.5x1.5 --primary \
                	--output DisplayPort-6 --pos 11520x0 --mode 1920x1080 --scale 2x2
	fi

	compton -CG &

	DISPLAY=:0 feh --bg-fill $1
	DISPLAY=:1 feh --bg-fill $1
	DISPLAY=:2 feh --bg-fill $1
	DISPLAY=:3 feh --bg-fill $1
fi
