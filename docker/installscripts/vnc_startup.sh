#!/bin/bash
source ~/.bashrc


./.noVNC/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NO_VNC_PORT & 


sleep 10 

vncserver -kill $DISPLAY \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix  \
    || echo "no locks present"


vncserver $DISPLAY PasswordFile=~/.vnc/passwd

~/.wm_startup.sh 


clear


echo -e "\nnoVNC HTML client started:\n\t=> connect via http://localhost:$NO_VNC_PORT\nPassword is hydrodynamics\n"

