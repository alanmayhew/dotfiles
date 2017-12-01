xrdb ~/.Xresources
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
# xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
# feh --randomize --recursive --bg-fill ~/wallpapers/*
redshift -l 42.7:73.7 &
# /home/mayhea/dwm-src/mystatus/stbar.sh &
exec dwm
