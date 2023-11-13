#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# First lunching is S, api_level is 31
PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_DTBO_TEMPLATE := $(LOCAL_PATH)/dt-overlay.in

include device/rockchip/common/build/rockchip/DynamicPartitions.mk
include $(LOCAL_PATH)/BoardConfig.mk
include device/rockchip/common/BoardConfig.mk
include $(LOCAL_PATH)/OtaConfig.mk

$(call inherit-product, device/rockchip/rk3588/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

DEVICE_PACKAGE_OVERLAYS += device/rockchip/rk3588/overlay
#PRODUCT_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_CHARACTERISTICS := tablet

BOARD ?= orangepi5
PRODUCT_NAME := orangepi5
PRODUCT_DEVICE := orangepi5
PRODUCT_BRAND := orangepi5
PRODUCT_MODEL := $(BOARD)
PRODUCT_MANUFACTURER := Xunlong
PRODUCT_AAPT_PREF_CONFIG := xhdpi
#
## add Rockchip properties
#
PRODUCT_PROPERTY_OVERRIDES += ro.sf.lcd_density=240
PRODUCT_PROPERTY_OVERRIDES += ro.wifi.sleep.power.down=true
PRODUCT_PROPERTY_OVERRIDES += persist.wifi.sleep.delay.ms=0
PRODUCT_PROPERTY_OVERRIDES += persist.bt.power.down=true
PRODUCT_PROPERTY_OVERRIDES += vendor.hwc.compose_policy=1
PRODUCT_PROPERTY_OVERRIDES += vendor.hwc.device.primary=DSI
PRODUCT_PROPERTY_OVERRIDES += vendor.hwc.device.extend=HDMI-A,eDP

#enable svep
BOARD_USES_LIBSVEP := true
PRODUCT_PROPERTY_OVERRIDES += persist.sys.svep.mode=1
#svep video policy, 0--no policy, 1--down 60fps video to 30fps when svep, 2--disable svep when 60fps video
PRODUCT_PROPERTY_OVERRIDES += sys.svep.policy=1

PRODUCT_PROPERTY_OVERRIDES += service.adb.tcp.port=5555
PRODUCT_PROPERTY_OVERRIDES += persist.sys.app.rotation=force_land

DUAL_LCD ?= false
AGING_TEST ?= false

ifeq ($(strip $(DUAL_LCD)), true)
	PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.primary_display_orientation=ORIENTATION_90
	#PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull=true
	#PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.einit-0 = 0
	#PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull-0 = true
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.einit-1 = 0
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull-1 = true
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.einit-2 = 1
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull-3 = true
ifeq ($(strip $(BOOT_DEVICE)), spi-sata)
	PRODUCT_KERNEL_DTS := rk3588s-orangepi-$(subst orangepi,,$(BOARD))-lcd-sata
	PRODUCT_UBOOT_CONFIG := rk3588-sata
else
	PRODUCT_KERNEL_DTS := rk3588s-orangepi-$(subst orangepi,,$(BOARD))-lcd
	PRODUCT_UBOOT_CONFIG := rk3588
endif

else
ifeq ($(strip $(BOOT_DEVICE)), spi-sata)
	PRODUCT_KERNEL_DTS := rk3588s-orangepi-$(subst orangepi,,$(BOARD))-sata
	PRODUCT_UBOOT_CONFIG := rk3588-sata
else
	#PRODUCT_PROPERTY_OVERRIDES += vendor.hwc.device.primary=DSI
	#PRODUCT_PROPERTY_OVERRIDES += vendor.hwc.device.extend=HDMI,DP
	PRODUCT_KERNEL_DTS := rk3588s-orangepi-$(subst orangepi,,$(BOARD))
	PRODUCT_UBOOT_CONFIG := rk3588
endif

endif

PRODUCT_COPY_FILES += $(LOCAL_PATH)/typec_usb2.sh:/vendor/bin/typec_usb2.sh
ifeq ($(strip $(AGING_TEST)), true)
	PRODUCT_COPY_FILES += $(LOCAL_PATH)/Aging_Test_Video.mp4:/vendor/test/Aging_Test_Video.mp4
	PRODUCT_COPY_FILES += $(LOCAL_PATH)/Aging_Test.bin:/vendor/test/Aging_Test.bin
	PRODUCT_COPY_FILES += $(LOCAL_PATH)/boot_start_Aging.sh:/vendor/bin/boot_start.sh
endif

#SYSTEM_TYPE ?= droid
#IMAGE_TYPE ?= cn
ifeq ($(strip $(SYSTEM_TYPE)), droid)
	PICTURE := $(shell ls $(LOCAL_PATH)/wallpaper)
	PRODUCT_COPY_FILES += \
	    $(foreach file, $(PICTURE), $(LOCAL_PATH)/wallpaper/$(file):/vendor/wallpaper/$(file))
	PRODUCT_COPY_FILES += $(LOCAL_PATH)/boot_start_droid.sh:/vendor/bin/boot_start.sh
	#PRODUCT_COPY_FILES += $(LOCAL_PATH)/com.android.chrome.zip:/vendor/com.android.chrome.zip
else
	PRODUCT_COPY_FILES += $(LOCAL_PATH)/boot_start.sh:/vendor/bin/boot_start.sh
endif

ifeq ($(strip $(IMAGE_TYPE)), cn)
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.timezone="Asia/Shanghai"
	PRODUCT_PROPERTY_OVERRIDES += ro.product.locale="zh-CN"
endif

BOARD_VENDOR_KERNEL_MODULES := \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8811cu/8821cu.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8188eu/8188eu.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8189es/8189es.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8189fs/8189fs.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8192eu/8192eu.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8723ds/8723ds.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8723du/8723du.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8812au/88XXau.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl8822bs/88x2bs.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl88x2bu/88x2bu.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/rtl88x2cs/88x2cs.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/bluetooth/rtk_btusb.ko \
	$(PRODUCT_KERNEL_PATH)/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.ko

PRODUCT_PACKAGES += wiringop gpiox

PRODUCT_PACKAGES += spidev_test spidev_fdx spiflash_test \
    candump canfdtest cangen canplayer cansend
	
PRODUCT_PACKAGES += uevents
