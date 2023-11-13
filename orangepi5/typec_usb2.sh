#!/system/bin/sh

echo host > /sys/kernel/debug/usb/fc000000.usb/mode

/system/bin/uevents
