#!/bin/bash

set -e

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../../.."
HELPER="${ANDROID_ROOT}/system/tools/hidl/update-makefiles-helper.sh"

MAKEFILES_LIST="\
  vendor.synaptics:device/meizu/sdm845-common/interfaces/synaptics\
  vendor.goodix:device/meizu/sdm845-common/interfaces/goodix"

source ${HELPER}

for makefile in ${MAKEFILES_LIST}
do
  do_makefiles_update ${makefile}
done

for file in $(find ${MY_DIR} -name "*.bp")
do
  sed -i '/system_ext_specific: true/d' ${file}
  sed -i '/gen_java: true/d' ${file}
done
