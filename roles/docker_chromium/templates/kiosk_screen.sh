#!/bin/bash
<<<<<<< HEAD
=======
@xset s noblank
@xset s off
@xset -dpms
>>>>>>> b5a54d0c7d21a3e5ea63e4ac238ef4b4a28a44e5

#unclutter -idle 0.5 -root &

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

/usr/bin/chromium-browser --force-device-scale-factor=0.5 --noerrdialogs --disable-infobars --window-size=480,320 --kiosk http://127.0.0.1 http://127.0.0.1:8080/index.html  &

while true; do
   xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
   sleep 10
done
