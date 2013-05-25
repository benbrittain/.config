xsetroot -cursor_name left_ptr
setxkbmap -layout dvorak
xrdb -merge ~/.Xresources

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 8 --transparent true --tint 0x000000 --height 20 &
nm-applet --sm-disable &
numlockx on
xscreensaver -nosplash &
feh  --bg-scale '/home/ben/milkyway.jpg' &
fluxgui &

exec ck-launch-session xmonad
