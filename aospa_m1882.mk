# Device supports 64-bit
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Use full-featured configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Launched with API 27
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_o_mr1.mk)

# m1882 configuration
$(call inherit-product, device/meizu/sdm845/m1882/m1882.mk)

# AOSPA configuration
$(call inherit-product, vendor/aospa/target/product/aospa-target.mk)

# Credits to XiNGRZ

PRODUCT_NAME := aospa_m1882
PRODUCT_BRAND := Meizu
PRODUCT_DEVICE := m1882
PRODUCT_MANUFACTURER := Meizu
PRODUCT_MODEL := 16th

PRODUCT_GMS_CLIENTID_BASE := android-meizu

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE="16th" \
    PRODUCT_NAME="meizu_16th_CN" \
    PRIVATE_BUILD_DESC="meizu_16th_CN-user 10 QKQ1.191222.002 1594833800 release-keys"

BUILD_FINGERPRINT := meizu/qssi/qssi:10/QKQ1.191222.002/1594833800:user/release-keys
