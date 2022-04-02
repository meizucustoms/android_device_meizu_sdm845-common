#
# Copyright (C) 2022 Paranoid Android
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

ifneq ($(filter m1882 m1892,$(TARGET_DEVICE)),

include $(CLEAR_VARS)

DTBO_BUILDER := $(HOST_OUT_EXECUTABLES)/dtboBuilderMeizuSDM845$(HOST_EXECUTABLE_SUFFIX)
DTC := $(HOST_OUT_EXECUTABLES)/dtc$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_DTBO_TARGET := $(PRODUCT_OUT)/vendor/etc/dtbo.img

define build_dtbo_meizu_sdm845
	$(call pretty,"Target empty dtbo image: $(INSTALLED_DTBOIMAGE_TARGET)")
	$(hide) $(DTC) \
			-I dts -O dtb \
			-b 0 -@ -H both \
			-o $(PRODUCT_OUT)/dtbo.dtb \
			$(LOCAL_PATH)/dtbo.dts
    $(hide) $(DTBO_BUILDER) $(PRODUCT_OUT)/dtbo.dtb $(INSTALLED_DTBO_TARGET)
	$(hide) $(AVBTOOL) add_hash_footer \
	    --image $(INSTALLED_DTBO_TARGET) \
	    --partition_size $(BOARD_DTBO_PARTITION_SIZE) \
	    --partition_name dtbo $(INTERNAL_AVB_SIGNING_ARGS)
endef

$(INSTALLED_DTBO_TARGET): $(DTBO_BUILDER) $(DTC) $(AVBTOOL)
	$(build_dtbo_meizu_sdm845)

ALL_DEFAULT_INSTALLED_MODULES += \
	$(INSTALLED_DTBO_TARGET)

endif
