# Copyright (C) 2009 The Android Open Source Project
# Copyright (c) 2011-2013, 2020 The Linux Foundation. All rights reserved.
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

import common
import re

def InstallDtboImage(script):
  indtbo = "/vendor/etc/dtbo.img"
  dtbobak = "/dev/block/platform/soc/1d84000.ufshc/by-name/dtbobak"
  dtbo = "/dev/block/platform/soc/1d84000.ufshc/by-name/dtbo"
  script.Mount("/vendor")
  script.Print("Patching DTBO...")
  script.AppendExtra('package_extract_file("%s", "%s");' % (indtbo, dtbo))
  script.AppendExtra('package_extract_file("%s", "%s");' % (indtbo, dtbobak))
  script.Unmount("/vendor")

def AddClearMeizuRoot(info):
  info.script.AppendExtra('meizu_sdm845.clear_mz_root();')
  return


def OTA_Assertions(info):
  AddClearMeizuRoot(info)
  return

def OTA_InstallEnd(info):
  InstallDtboImage(info.script)
  return


def FullOTA_Assertions(info):
  OTA_Assertions(info)
  return

def IncrementalOTA_Assertions(info):
  OTA_Assertions(info)
  return

def FullOTA_InstallEnd(info):
  OTA_InstallEnd(info)
  return

def IncrementalOTA_InstallEnd(info):
  OTA_InstallEnd(info)
  return

