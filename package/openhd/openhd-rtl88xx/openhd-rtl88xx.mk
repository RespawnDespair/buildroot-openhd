OPENHD_RTL88XX_VERSION = v5.2.20
OPENHD_RTL88XX_SITE = https://github.com/aircrack-ng/rtl8812au.git
OPENHD_RTL88XX_SITE_METHOD = git
OPENHD_RTL88XX_INSTALL_STAGING = YES
OPENHD_RTL88XX_LICENSE = GPL-2.0
OPENHD_RTL88XX_LICENSE_FILES = COPYING
OPENHD_RTL88XX_MODULE_MAKE_OPTS = CONFIG_PLATFORM_ARM_SUNxI=y CONFIG_PLATFORM_I386=n 

# Build the core of open.hd
define OPENHD_RTL88XX_BUILD_CMDS
	$(OPENHD_RTL88XX_MODULE_MAKE_OPTS) USER_EXTRA_CFLAGS="-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN \
		-Wno-error" $(MAKE) -C $(@D) 
endef

# After a successfull build, copy all the relevant core files
define OPENHD_RTL88XX_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/net/wireless/
	$(INSTALL) -p -m 644 $(@D)/88XXau.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/net/wireless/
	# Add this to the default modprobe /etc/init.d/S99modules if required 
  	touch $(TARGET_DIR)/etc/init.d/S99modules 
	echo "modprobe 88XXau" >> $(TARGET_DIR)/etc/init.d/S99modules

	# modprobe 88XXau
endef

$(eval $(generic-package))