#!/system/bin/sh

echo host > /sys/kernel/debug/usb/fc000000.usb/mode

/system/bin/uevents &

sleep 10
if [ ! -f /sdcard/Pictures/.wallpaper ];then
        cp /vendor/wallpaper/*.jpg /sdcard/Pictures -rf
        touch /sdcard/Pictures/.wallpaper
fi

