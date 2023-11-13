#!/system/bin/sh

do_gpio_test()
{
	while true
	do
		for i in 47 46 54 131 132 138 29 139 28 59 58 49 48 50 92 52 35
		do
		        [ ! -d /sys/class/gpio/gpio${i} ] && echo $i > /sys/class/gpio/export
		        echo out > /sys/class/gpio/gpio${i}/direction
		        echo 1 > /sys/class/gpio/gpio${i}/value
		done
		sleep 1
		for i in 47 46 54 131 132 138 29 139 28 59 58 49 48 50 92 52 35
		do
		        [ ! -d /sys/class/gpio/gpio${i} ] && echo $i > /sys/class/gpio/export
		        echo out > /sys/class/gpio/gpio${i}/direction
		        echo 0 > /sys/class/gpio/gpio${i}/value
		done
		sleep 1
	done
}

#do_gpio_test &

#if [ -c /dev/mtd0 ]; then
#	echo none > /sys/class/leds/status_led/trigger
#	echo 1 > /sys/class/leds/status_led/brightness
#fi

sleep 5
if [ ! -f /sdcard/.test ];then
        cp /vendor/test/* /sdcard/ -rf
        touch /sdcard/.test
	sync
fi


