#!/bin/sh

ACTION=`zenity --width=90 --height=150 --list --text="Select logout action" --title="Logout" --column "Action" Shutdown Reboot`

if [ -n "${ACTION}" ];then
 case $ACTION in
 Shutdown)
   shutdown
   ;;
 Reboot)
   reboot
   ;;
 esac
fi
