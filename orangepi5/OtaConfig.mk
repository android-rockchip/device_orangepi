IMAGE_TYPE ?= en
SYSTEM_TYPE ?= android
IMAGE_VERSION ?= 1.0.0
BOOT_DEVICE ?= normal
PRODUCT_PROPERTY_OVERRIDES += ro.product.image.type = $(IMAGE_TYPE)
PRODUCT_PROPERTY_OVERRIDES += ro.product.system.type = $(SYSTEM_TYPE)
PRODUCT_PROPERTY_OVERRIDES += ro.product.boot.device = $(BOOT_DEVICE)
PRODUCT_PROPERTY_OVERRIDES += ro.product.ota.host = www.iplaystore.cn:32300
PRODUCT_PROPERTY_OVERRIDES += ro.product.ota.host2 = 123.57.154.183:32300
PRODUCT_PROPERTY_OVERRIDES += ro.product.version = $(IMAGE_VERSION)
ROCKCHIP_BUILD_NUMBER := eng.$(shell echo $${BUILD_USERNAME:0:8}).$(shell $(DATE) +%Y%m%d).v$(IMAGE_VERSION)
