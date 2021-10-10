# Target architectures supported by u-boot in Debian.
# debian/rules includes this Makefile snippet.

# This dependency holds on both arm64 and armhf.
# https://bugs.debian.org/cgi-bin/bugreport.cgi?att=0;bug=979483;msg=22
u-boot-rockchip: debian/build/rockchip_make_fit_atf
debian/build/rockchip_make_fit_atf: arch/arm/mach-rockchip/make_fit_atf.py
	mkdir -p debian/build
	sed '1 s,/usr/bin/env python.*,/usr/bin/python3,' \
	  arch/arm/mach-rockchip/make_fit_atf.py > debian/build/rockchip_make_fit_atf
	chmod +x debian/build/rockchip_make_fit_atf

ifeq (${DEB_HOST_ARCH},arm64)

# u-boot-amlogic

  # Neil Armstrong <narmstrong@baylibre.com>
  u-boot-amlogic_platforms += khadas-vim
  khadas-vim_targets := u-boot.bin uboot.elf

  # Neil Armstrong <narmstrong@baylibre.com>
  u-boot-amlogic_platforms += khadas-vim2
  khadas-vim2_targets := u-boot.bin uboot.elf

  # Frederic Danis <frederic.danis@collabora.com>
  u-boot-amlogic_platforms += libretech-cc
  libretech-cc_targets := u-boot.bin uboot.elf

  # Neil Armstrong <narmstrong@baylibre.com>
  u-boot-amlogic_platforms += nanopi-k2
  nanopi-k2_targets := u-boot.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-amlogic_platforms += odroid-c2
  odroid-c2_targets := u-boot.bin uboot.elf

  # Reco <bugs@enotuniq.net>
  u-boot-amlogic_platforms += odroid-n2
  odroid-n2_targets := u-boot.bin uboot.elf

# u-boot-mvebu

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-mvebu_platforms += mvebu_espressobin-88f3720
  mvebu_espressobin-88f3720_targets := \
    arch/arm/dts/armada-3720-espressobin.dtb u-boot.bin uboot.elf

# u-boot-qcom

  # Riku Voipio <riku.voipio@linaro.org>
  u-boot-qcom_platforms += dragonboard410c
  dragonboard410c_targets := u-boot.bin uboot.elf

  # Riku Voipio <riku.voipio@linaro.org>
  u-boot-qcom_platforms += dragonboard820c
  dragonboard820c_targets := u-boot.bin uboot.elf

# u-boot-rockchip

  dpkg-gencontrol_args += "-Vu-boot-rockchip:Built-Using=$(shell dpkg-query -Wf \
    '$${source:Package} (= $${source:Version})' arm-trusted-firmware)"

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-rockchip_platforms += firefly-rk3399
  firefly-rk3399_assigns := BL31=/usr/lib/arm-trusted-firmware/rk3399/bl31.elf
  firefly-rk3399_targets := arch/arm/dts/rk3399-firefly.dtb idbloader.img \
    spl/u-boot-spl.bin tpl/u-boot-tpl.bin u-boot-nodtb.bin u-boot.bin \
    u-boot.img u-boot.itb uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-rockchip_platforms += pinebook-pro-rk3399
  pinebook-pro-rk3399_assigns := BL31=/usr/lib/arm-trusted-firmware/rk3399/bl31.elf
  pinebook-pro-rk3399_targets := arch/arm/dts/rk3399-pinebook-pro.dtb \
    idbloader.img spl/u-boot-spl.bin tpl/u-boot-tpl.bin u-boot-nodtb.bin \
    u-boot.bin u-boot.img u-boot.itb uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-rockchip_platforms += puma-rk3399
  puma-rk3399_assigns := BL31=/usr/lib/arm-trusted-firmware/rk3399/bl31.elf
  puma-rk3399_targets := arch/arm/dts/rk3399-puma-haikou.dtb idbloader.img \
    spl/u-boot-spl.bin u-boot-nodtb.bin u-boot.bin u-boot.img u-boot.itb \
    uboot.elf

  # Walter Lozano <walter.lozano@collabora.com>
  u-boot-rockchip_platforms += rock-pi-4-rk3399
  rock-pi-4-rk3399_assigns := BL31=/usr/lib/arm-trusted-firmware/rk3399/bl31.elf
  rock-pi-4-rk3399_targets := arch/arm/dts/rk3399-rock-pi-4a.dtb \
    arch/arm/dts/rk3399-rock-pi-4b.dtb idbloader.img spl/u-boot-spl.bin \
    tpl/u-boot-tpl.bin u-boot-nodtb.bin u-boot.bin u-boot.img u-boot.itb \
    uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-rockchip_platforms += rock64-rk3328
  rock64-rk3328_assigns := BL31=/usr/lib/arm-trusted-firmware/rk3328/bl31.elf
  rock64-rk3328_targets := arch/arm/dts/rk3328-rock64.dtb idbloader.img \
    spl/u-boot-spl.bin tpl/u-boot-tpl.bin u-boot-nodtb.bin u-boot.bin \
    u-boot.img u-boot.itb uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-rockchip_platforms += rockpro64-rk3399
  rockpro64-rk3399_assigns := BL31=/usr/lib/arm-trusted-firmware/rk3399/bl31.elf
  rockpro64-rk3399_targets := arch/arm/dts/rk3399-rockpro64.dtb \
    idbloader.img spl/u-boot-spl.bin tpl/u-boot-tpl.bin u-boot-nodtb.bin \
    u-boot.bin u-boot.img u-boot.itb uboot.elf

# u-boot-rpi

  # Ryan Finnie <ryan@finnie.org>
  u-boot-rpi_platforms += rpi_3
  rpi_3_targets := u-boot.bin uboot.elf

  # Lucas Nussbaum <lucas@debian.org>
  # Andreas Henriksson <andreas@fatal.se>
  u-boot-rpi_platforms += rpi_4
  rpi_4_targets := u-boot.bin uboot.elf

  # Denis Pynkin <denis.pynkin@collabora.com>
  u-boot-rpi_platforms += rpi_arm64
  rpi_arm64_targets := u-boot.bin uboot.elf

# u-boot-sunxi

  u-boot-sunxi_assigns = \
    SCP=$(or $(wildcard /usr/lib/crust-firmware/$(platform).bin),/dev/null)

  dpkg-gencontrol_args += "-Vu-boot-sunxi:Built-Using=$(shell dpkg-query -Wf \
    '$${source:Package} (= $${source:Version})' arm-trusted-firmware)"

  # Rodrigo Exterckötter Tjäder <rodrigo@tjader.xyz>
  u-boot-sunxi_platforms += a64-olinuxino
  a64-olinuxino_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  a64-olinuxino_targets := arch/arm/dts/sun50i-a64-olinuxino.dtb \
    spl/sunxi-spl.bin u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb \
    u-boot.bin uboot.elf

  # Philip Rinn <rinni@inventati.org>
  u-boot-sunxi_platforms += a64-olinuxino-emmc
  a64-olinuxino-emmc_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  a64-olinuxino-emmc_targets := arch/arm/dts/sun50i-a64-olinuxino-emmc.dtb \
    spl/sunxi-spl.bin u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb \
    u-boot.bin uboot.elf

  # Domenico Andreoli <cavok@debian.org>
  u-boot-sunxi_platforms += nanopi_neo2
  nanopi_neo2_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  nanopi_neo2_targets := arch/arm/dts/sun50i-h5-nanopi-neo2.dtb \
    spl/sunxi-spl.bin u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb \
    u-boot.bin uboot.elf

  # Steev Klimaszewski <steev@kali.org>
  u-boot-sunxi_platforms += nanopi_neo_plus2
  nanopi_neo_plus2_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  nanopi_neo_plus2_targets := arch/arm/dts/sun50i-h5-nanopi-neo-plus2.dtb \
    spl/sunxi-spl.bin u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb \
    u-boot.bin uboot.elf

  # harry88@gmx.ph
  u-boot-sunxi_platforms += orangepi_one_plus
  orangepi_one_plus_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_h6/bl31.bin
  orangepi_one_plus_targets := arch/arm/dts/sun50i-h6-orangepi-one-plus.dtb \
    spl/sunxi-spl.bin u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb \
    u-boot.bin uboot.elf

  # Frederic Danis <frederic.danis@collabora.com>
  u-boot-sunxi_platforms += orangepi_zero_plus2
  orangepi_zero_plus2_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  orangepi_zero_plus2_targets := \
    arch/arm/dts/sun50i-h5-orangepi-zero-plus2.dtb spl/sunxi-spl.bin \
    u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # Sunil Mohan Adapa <sunil@medhas.org>
  u-boot-sunxi_platforms += pine64-lts
  pine64-lts_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  pine64-lts_targets := arch/arm/dts/sun50i-a64-pine64-lts.dtb \
    arch/arm/dts/sun50i-a64-pine64.dtb spl/sunxi-spl.bin u-boot-nodtb.bin \
    u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += pine64_plus
  pine64_plus_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  pine64_plus_targets := arch/arm/dts/sun50i-a64-pine64-plus.dtb \
    arch/arm/dts/sun50i-a64-pine64.dtb spl/sunxi-spl.bin u-boot-nodtb.bin \
    u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += pinebook
  pinebook_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  pinebook_targets := arch/arm/dts/sun50i-a64-pinebook.dtb spl/sunxi-spl.bin \
    u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # Benoit Delcour <benoit.delcour@gmail.com> (1.2)
  # Arnaud Ferraris <arnaud.ferraris@collabora.com> (1.1, 1.2)
  u-boot-sunxi_platforms += pinephone
  pinephone_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  pinephone_targets := arch/arm/dts/sun50i-a64-pinephone-1.1.dtb \
    arch/arm/dts/sun50i-a64-pinephone-1.2.dtb spl/sunxi-spl.bin \
    u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # Arnaud Ferraris <arnaud.ferraris@collabora.com>
  u-boot-sunxi_platforms += pinetab
  pinetab_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  pinetab_targets := arch/arm/dts/sun50i-a64-pinetab.dtb spl/sunxi-spl.bin \
    u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # amarpreet@minhas.io
  u-boot-sunxi_platforms += sopine_baseboard
  sopine_baseboard_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  sopine_baseboard_targets := arch/arm/dts/sun50i-a64-sopine-baseboard.dtb spl/sunxi-spl.bin \
    u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

  # Jonas Smedegaard <dr@jones.dk>
  u-boot-sunxi_platforms += teres_i
  teres_i_assigns := BL31=/usr/lib/arm-trusted-firmware/sun50i_a64/bl31.bin
  teres_i_targets := arch/arm/dts/sun50i-a64-teres-i.dtb spl/sunxi-spl.bin \
    u-boot-nodtb.bin u-boot-sunxi-with-spl.fit.itb u-boot.bin uboot.elf

# u-boot-tegra

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-tegra_platforms += p2371-2180
  p2371-2180_targets := u-boot.bin uboot.elf

else ifeq (${DEB_HOST_ARCH},armel)

# u-boot

  u-boot_platforms += dockstar
  dockstar_targets := u-boot.kwb uboot.elf

  # Ian Campbell <ijc@debian.org>
  u-boot_platforms += dreamplug
  dreamplug_targets := u-boot.kwb uboot.elf

  # drEagle <drEagle@doukki.net>
  u-boot_platforms += guruplug
  guruplug_targets := u-boot.kwb uboot.elf

  # drEagle <drEagle@doukki.net>
  # Rick Thomas <rbthomas@rcthomas.org>
  u-boot_platforms += sheevaplug
  sheevaplug_targets := u-boot.kwb uboot.elf

# u-boot-rpi

  # Vagrant Cascadian <vagrant@debian.org>, rpi B 256M
  u-boot-rpi_platforms += rpi
  rpi_targets := u-boot.bin uboot.elf

  # Romain Perier <romain.perier@gmail.com>, rpi zero w
  u-boot-rpi_platforms += rpi_0_w
  rpi_0_w_targets := u-boot.bin uboot.elf

else ifeq (${DEB_HOST_ARCH},armhf)

# u-boot-exynos

  u-boot-exynos_platforms += arndale
  arndale_targets := spl/arndale-spl.bin u-boot.bin uboot.elf

  # Joost van Zwieten <joostvanzwieten@gmail.com>, Odroid-U3
  u-boot-exynos_platforms += odroid
  odroid_targets := u-boot.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>, Odroid-XU4
  u-boot-exynos_platforms += odroid-xu3
  odroid-xu3_targets := u-boot.bin uboot.elf

# u-boot-imx

  # Marek Vasut <marex@denx.de>
  u-boot-imx_platforms += dh_imx6
  dh_imx6_targets := u-boot-with-spl.imx uboot.elf

  # Robert Nelson <robertcnelson@gmail.com>
  u-boot-imx_platforms += mx53loco
  mx53loco_targets := u-boot-dtb.imx uboot.elf

  # Steve Langasek <vorlon@debian.org>, CuBox-i4
  # Vagrant Cascadian <vagrant@debian.org>, CuBox-i4pro, Cubox-i4x4, hummingboard-i1, hummingboard-i2ex
  # Rainer Dorsch <ml@bokomoko.de>, CuBox-i2u (i2u-300-d)
  # Rick Thomas <rbthomas@pobox.com>, Cubox-i4x4, Cubox-i4PRO
  u-boot-imx_platforms += mx6cuboxi
  mx6cuboxi_targets := SPL u-boot.img uboot.elf

  # Martyn Welch <martyn.welch@collabora.com>
  u-boot-imx_platforms += mx6qsabrelite
  mx6qsabrelite_targets := u-boot-dtb.imx uboot.elf

  # Hector Oron <zumbi@debian.org>
  u-boot-imx_platforms += nitrogen6q
  nitrogen6q_targets := u-boot-dtb.imx uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-imx_platforms += novena
  novena_targets := SPL u-boot.img uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-imx_platforms += novena-rawsd
  novena-rawsd_targets := SPL

  novena-rawsd: configs/novena-rawsd_defconfig
  configs/novena-rawsd_defconfig: configs/novena_defconfig
	sed -e 's,CONFIG_SPL_FS_FAT=y,# CONFIG_SPL_FS_FAT is not set,' \
		configs/novena_defconfig > configs/novena-rawsd_defconfig
  dh_clean_args += configs/novena-rawsd_defconfig

  # Michael Fladischer <michael@fladi.at>
  u-boot-imx_platforms += udoo
  udoo_targets := SPL u-boot.img uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-imx_platforms += usbarmory
  usbarmory_targets := u-boot-dtb.imx uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  # Robert Nelson <robertcnelson@gmail.com>
  u-boot-imx_platforms += wandboard
  wandboard_targets := SPL u-boot.img uboot.elf

# u-boot-omap

  # Vagrant Cascadian <vagrant@debian.org>
  # Andrew M.A. Cater <amacater@galactic.demon.co.uk>
  u-boot-omap_platforms += am335x_boneblack
  am335x_boneblack_targets := MLO u-boot.img uboot.elf

  am335x_boneblack: configs/am335x_boneblack_defconfig
  configs/am335x_boneblack_defconfig: configs/am335x_evm_defconfig
	sed -e 's,CONFIG_OF_LIST=.*,CONFIG_OF_LIST="am335x-evm am335x-boneblack",g' \
		configs/am335x_evm_defconfig > configs/am335x_boneblack_defconfig
  dh_clean_args += configs/am335x_boneblack_defconfig

  # Vagrant Cascadian <vagrant@debian.org>
  # Andrew M.A. Cater <amacater@galactic.demon.co.uk>
  u-boot-omap_platforms += am335x_evm
  am335x_evm_targets := MLO u-boot.img uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-omap_platforms += am57xx_evm
  am57xx_evm_targets := MLO u-boot.img uboot.elf

  u-boot-omap_platforms += dra7xx_evm
  dra7xx_evm_targets := MLO u-boot.img uboot.elf

  # Robert Nelson <robertcnelson@gmail.com>
  u-boot-omap_platforms += igep00x0
  igep00x0_targets := MLO u-boot.img uboot.elf

  u-boot-omap_platforms += nokia_rx51
  nokia_rx51_targets := u-boot.bin uboot.elf

  # Robert Nelson <robertcnelson@gmail.com>
  u-boot-omap_platforms += omap3_beagle
  omap3_beagle_targets := MLO u-boot.img uboot.elf

  # Robert Nelson <robertcnelson@gmail.com>
  u-boot-omap_platforms += omap4_panda
  omap4_panda_targets := MLO u-boot.img uboot.elf

# u-boot-rockchip

  # Silent a debhelper warning about an unused substvar.
  dpkg-gencontrol_args += -Vu-boot-rockchip:Built-Using=

  # Vagrant Cascadian <vagrant@debian.org>, 2GB and 4GB variants
  u-boot-rockchip_platforms += firefly-rk3288
  firefly-rk3288_targets := idbloader.img spl/u-boot-spl.bin u-boot.bin \
    u-boot.img uboot.elf

# u-boot-rpi

  # Vagrant Cascadian <vagrant@debian.org>, Raspberry PI 2B
  u-boot-rpi_platforms += rpi_2
  rpi_2_targets := u-boot.bin uboot.elf

  # Ryan Finnie <ryan@finnie.org>
  u-boot-rpi_platforms += rpi_3_32b
  rpi_3_32b_targets := u-boot.bin uboot.elf

  # Lucas Nussbaum <lucas@debian.org>
  # Andreas Henriksson <andreas@fatal.se>
  u-boot-rpi_platforms += rpi_4_32b
  rpi_4_32b_targets := u-boot.bin uboot.elf

# u-boot-sunxi

  # Silent a debhelper warning about an unused substvar.
  dpkg-gencontrol_args += -Vu-boot-sunxi:Built-Using=

  # Christian Kastner <debian@kvr.at>
  u-boot-sunxi_platforms += A10-OLinuXino-Lime
  A10-OLinuXino-Lime_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Benedikt Wildenhain <esperanto@benedikt-wildenhain.de>
  u-boot-sunxi_platforms += A10s-OLinuXino-M
  A10s-OLinuXino-M_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Christian Kastner <debian@kvr.at>
  u-boot-sunxi_platforms += A20-OLinuXino-Lime
  A20-OLinuXino-Lime_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Karsten Merker <merker@debian.org>
  u-boot-sunxi_platforms += A20-OLinuXino-Lime2
  A20-OLinuXino-Lime2_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Andreas B. Mundt <andi@debian.org>
  u-boot-sunxi_platforms += A20-OLinuXino-Lime2-eMMC
  A20-OLinuXino-Lime2-eMMC_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Arne Ploese <aploese@gmx.de>
  u-boot-sunxi_platforms += A20-OLinuXino_MICRO
  A20-OLinuXino_MICRO_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Karsten Merker <merker@debian.org>
  u-boot-sunxi_platforms += A20-Olimex-SOM-EVB
  A20-Olimex-SOM-EVB_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Ian Campbell <ijc@debian.org>
  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += Bananapi
  Bananapi_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Bernhard Wörner <bewoern1@gmail.com>
  u-boot-sunxi_platforms += Bananapi_M2_Ultra
  Bananapi_M2_Ultra_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Karsten Merker <merker@debian.org>
  u-boot-sunxi_platforms += Bananapro
  Bananapro_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += CHIP
  CHIP_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += Cubieboard
  Cubieboard_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Ian Campbell <ijc@debian.org>
  # Karsten Merker <merker@debian.org>
  u-boot-sunxi_platforms += Cubieboard2
  Cubieboard2_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += Cubieboard4
  Cubieboard4_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Ian Campbell <ijc@debian.org>
  # Robert Nelson <robertcnelson@gmail.com>
  # Karsten Merker <merker@debian.org>
  u-boot-sunxi_platforms += Cubietruck
  Cubietruck_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += Cubietruck_plus
  Cubietruck_plus_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sunxi_platforms += Lamobo_R1
  Lamobo_R1_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Robert Hegner <rhegner@hsr.ch>
  u-boot-sunxi_platforms += Linksprite_pcDuino
  Linksprite_pcDuino_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Patrice Go <patgsiosisr@gmail.com>
  u-boot-sunxi_platforms += Linksprite_pcDuino3
  Linksprite_pcDuino3_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Jochen Sprickerhof <debian@jochen.sprickerhof.de>
  u-boot-sunxi_platforms += Mini-X
  Mini-X_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Bernhard <bewoern1@gmail.com>
  u-boot-sunxi_platforms += Sinovoip_BPI_M3
  Sinovoip_BPI_M3_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Lucas Nussbaum <lucas@debian.org>
  u-boot-sunxi_platforms += bananapi_m2_berry
  bananapi_m2_berry_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Paul Tagliamonte <paultag@debian.org>
  u-boot-sunxi_platforms += nanopi_neo
  nanopi_neo_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Philip Hands <phil@hands.com>
  u-boot-sunxi_platforms += nanopi_neo_air
  nanopi_neo_air_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Vagrant Cascadian <vagrant@debian.org>, Orange PI Plus2
  u-boot-sunxi_platforms += orangepi_plus
  orangepi_plus_targets := u-boot-sunxi-with-spl.bin uboot.elf

  # Mateusz Łukasik <mati75@linuxmint.pl>, Orange PI Zero
  u-boot-sunxi_platforms += orangepi_zero
  orangepi_zero_targets := u-boot-sunxi-with-spl.bin uboot.elf

# u-boot-tegra

  # Ian Campbell <ijc@debian.org>
  u-boot-tegra_platforms += jetson-tk1
  jetson-tk1_targets := u-boot-tegra.bin uboot.elf

else ifeq (${DEB_HOST_ARCH},avr32)

# u-boot

  u-boot_platforms += hammerhead
  hammerhead_targets := u-boot.img uboot.elf

else ifeq (${DEB_HOST_ARCH},riscv64)

# u-boot-sifive

  dpkg-gencontrol_args += "-Vu-boot-sifive:Built-Using=$(shell dpkg-query -Wf \
    '$${source:Package} (= $${source:Version})' opensbi)"

  # Hector Oron <zumbi@debian.org>
  u-boot-sifive_platforms += sifive_unleashed
  sifive_unleashed_targets := u-boot.bin uboot.elf spl/u-boot-spl.bin u-boot.itb
  sifive_unleased_assigns := OPENSBI=/usr/lib/riscv64-linux-gnu/opensbi/generic/fw_dynamic.bin

  # Vagrant Cascadian <vagrant@debian.org>
  u-boot-sifive_platforms += sifive_unmatched
  sifive_unmatched_targets := u-boot.bin uboot.elf spl/u-boot-spl.bin u-boot.itb
  sifive_unmatched_assigns := OPENSBI=/usr/lib/riscv64-linux-gnu/opensbi/generic/fw_dynamic.bin

else ifeq (${DEB_HOST_ARCH},sh4)

# u-boot

  u-boot_platforms += r2dplus
  r2dplus_targets := u-boot.bin uboot.elf

endif

# u-boot-qemu (Architecture: all)

  u-boot-qemu_platforms += qemu-ppce500
  qemu-ppce500_CROSS_COMPILE := powerpc-linux-gnu-
  qemu-ppce500_targets := u-boot.bin uboot.elf

  u-boot-qemu_platforms += qemu-riscv64
  qemu-riscv64_CROSS_COMPILE := riscv64-linux-gnu-
  qemu-riscv64_targets := u-boot.bin uboot.elf

  u-boot-qemu_platforms += qemu-riscv64_smode
  qemu-riscv64_smode_CROSS_COMPILE := riscv64-linux-gnu-
  qemu-riscv64_smode_targets := u-boot.bin uboot.elf

  u-boot-qemu_platforms += qemu-x86
  qemu-x86_CROSS_COMPILE := i686-linux-gnu-
  qemu-x86_targets := u-boot.bin u-boot.rom uboot.elf

  u-boot-qemu_platforms += qemu-x86_64
  qemu-x86_64_CROSS_COMPILE := x86_64-linux-gnu-
  qemu-x86_64_targets := u-boot.bin u-boot.rom uboot.elf

  u-boot-qemu_platforms += qemu_arm
  qemu_arm_CROSS_COMPILE := arm-linux-gnueabihf-
  qemu_arm_targets := u-boot.bin uboot.elf

  u-boot-qemu_platforms += qemu_arm64
  qemu_arm64_CROSS_COMPILE := aarch64-linux-gnu-
  qemu_arm64_targets := u-boot.bin uboot.elf
