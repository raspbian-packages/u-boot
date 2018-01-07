/*
 * (C) Copyright 2015 Google, Inc
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#define ROCKCHIP_DEVICE_SETTINGS \
		"fdtfile=" CONFIG_DEFAULT_DEVICE_TREE ".dtb\0" \
		"stdin=serial,usbkbd\0" \
		"stdout=serial,vidconsole\0" \
		"stderr=serial,vidconsole\0" \
		"preboot=usb start\0"

#include <configs/rk3288_common.h>

#define CONFIG_SYS_MMC_ENV_DEV 0

#endif
