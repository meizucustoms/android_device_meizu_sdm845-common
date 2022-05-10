LOCAL_PATH := $(call my-dir)

TARGET_KERNEL_ADDITIONAL_FLAGS := \
    DTC_OVERLAY_TEST_EXT=$(shell pwd)/$(HOST_OUT_EXECUTABLES)/ufdt_apply_overlay
TARGET_KERNEL_ADDITIONAL_DEPENDENCIES := \
    $(HOST_OUT_EXECUTABLES)/ufdt_apply_overlay

include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk
