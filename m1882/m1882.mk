# Proprietary blobs
$(call inherit-product, vendor/meizu/m1882/m1882-vendor.mk)

# Common configuration
$(call inherit-product, device/meizu/sdm845/sdm845.mk)

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay-m1882

# Meizu property
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.flyme.model=M1882
