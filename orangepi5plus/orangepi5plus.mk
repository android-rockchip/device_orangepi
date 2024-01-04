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
include $(LOCAL_PATH)/../ota.mk

$(call inherit-product, device/rockchip/rk3588/device.mk)
$(call inherit-product, device/rockchip/common/device.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

DEVICE_PACKAGE_OVERLAYS += device/rockchip/rk3588/overlay
#PRODUCT_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

PRODUCT_CHARACTERISTICS := tablet

BOARD ?= orangepi5plus
PRODUCT_NAME := orangepi5plus
PRODUCT_DEVICE := orangepi5plus
PRODUCT_BRAND := orangepi5plus
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
PRODUCT_PROPERTY_OVERRIDES += sys.mouse.presentation=1

PRODUCT_PROPERTY_OVERRIDES += service.adb.tcp.port=5555
PRODUCT_PROPERTY_OVERRIDES += persist.sys.app.rotation=force_land
PRODUCT_KERNEL_DTS := rk3588-orangepi-5-plus

BOARD_HDMI_IN_SUPPORT:=true

DUAL_LCD ?= false
AGING_TEST ?= false

ifeq ($(strip $(DUAL_LCD)), true)
        PRODUCT_PROPERTY_OVERRIDES += ro.surface_flinger.primary_display_orientation=ORIENTATION_90
        PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull-1 = true
        PRODUCT_PROPERTY_OVERRIDES += persist.sys.rotation.efull-2 = true
        PRODUCT_KERNEL_DTS := rk3588-orangepi-$(subst orangepi,,$(BOARD))-lcd
endif

ifeq ($(strip $(AGING_TEST)), true)
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/Aging_Test_Video.mp4:/vendor/test/Aging_Test_Video.mp4
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/Aging_Test.bin:/vendor/test/Aging_Test.bin
        PRODUCT_COPY_FILES += $(LOCAL_PATH)/boot_start_Aging.sh:/vendor/bin/boot_start.sh
endif

PRODUCT_KERNEL_CONFIG += pcie_wifi_ax.config

# copy input keylayout and device config
keylayout_files := $(shell ls $(LOCAL_PATH)/remote_config )
PRODUCT_COPY_FILES += \
        $(foreach file, $(keylayout_files), $(LOCAL_PATH)/remote_config/$(file):$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/$(file))

PRODUCT_PACKAGES += wiringop gpiox

PRODUCT_PACKAGES += spidev_test spidev_fdx spiflash_test \
    candump canfdtest cangen canplayer cansend

PRODUCT_PACKAGES += uevents

include device/extra/extra.mk
