#!/bin/bash
#xset s noblank
#xset s off
#xset -dpms

#unclutter -idle 0.5 -root &
export DISPLAY=:0.0

#sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
#sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

chromium-browser --force-device-scale-factor=0.5 --noerrdialogs --disable-infobars --window-size=480,320 http://127.0.0.1:1880/ui  &

#--kiosk
while true; do
   xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
   sleep 10
done
