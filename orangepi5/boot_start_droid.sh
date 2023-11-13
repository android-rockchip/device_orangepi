#!/system/bin/sh

sleep 10
if [ ! -f /sdcard/Pictures/.wallpaper ];then
        cp /vendor/wallpaper/*.jpg /sdcard/Pictures -rf
        touch /sdcard/Pictures/.wallpaper
fi

#if [ ! -f /data/data/com.android.chrome/.test ];then
#	unzip -o /vendor/com.android.chrome.zip -d /data/data/ > /dev/null 2>&1
#	touch /data/data/com.android.chrome/.test
#fi
