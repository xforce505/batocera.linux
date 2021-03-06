################################################################################
#
# mali g31
#
################################################################################
# Version.: Commits on Nov 13, 2019
MALI_G31_VERSION = d4000def121b818ae0f583d8372d57643f723fdc
MALI_G31_SITE = $(call github,LibreELEC,libmali,$(MALI_G31_VERSION))
MALI_G31_INSTALL_STAGING = YES
MALI_G31_PROVIDES = libegl libgles
MALI_G31_DEPENDENCIES = mali-bifrost-module

MALI_G31_BLOB_FILENAME = libmali-bifrost-g31-r16p0-gbm.so

ifeq ($(BR2_arm),y)
MALI_G31_BLOB = $(@D)/lib/arm-linux-gnueabihf/$(MALI_G31_BLOB_FILENAME)
else
MALI_G31_BLOB = $(@D)/lib/aarch64-linux-gnu/$(MALI_G31_BLOB_FILENAME)
endif

define MALI_G31_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib/pkgconfig

	cp $(MALI_G31_BLOB) $(STAGING_DIR)/usr/lib/libmali.so

	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libMali.so)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libEGL.so)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libEGL.so.1)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libGLESv1_CM.so)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libGLESv1_CM.so.1)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libGLESv2.so)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libGLESv2.so.2)
	(cd $(STAGING_DIR)/usr/lib && ln -sf libmali.so libgbm.so)

	cp -pr $(@D)/include    $(STAGING_DIR)/usr
	cp $(@D)/include/gbm.h 	$(STAGING_DIR)/usr/include/gbm.h

	for X in gbm egl glesv1_cm glesv2; \
	do \
		cp $(@D)/pkgconfig/$${X}.pc.cmake                 	$(STAGING_DIR)/usr/lib/pkgconfig/$${X}.pc; \
		sed -i -e s+@CMAKE_INSTALL_INCLUDEDIR@+include+g 	$(STAGING_DIR)/usr/lib/pkgconfig/$${X}.pc; \
		sed -i -e s+@CMAKE_INSTALL_LIBDIR@+lib+g         	$(STAGING_DIR)/usr/lib/pkgconfig/$${X}.pc; \
	done
endef

define MALI_G31_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib

	cp $(MALI_G31_BLOB) $(TARGET_DIR)/usr/lib/libmali.so

	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libMali.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libEGL.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libEGL.so.1)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libGLESv1_CM.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libGLESv1_CM.so.1)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libGLESv2.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libGLESv2.so.2)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libmali.so libgbm.so)
endef

$(eval $(generic-package))
