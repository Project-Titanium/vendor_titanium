PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/pti/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/pti/prebuilt/common/bin/50-pti.sh:system/addon.d/50-pti.sh \
    vendor/pti/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/pti/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/pti/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/pti/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Pti-specific init file
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/etc/init.local.rc:root/init.pti.rc

# Copy LatinIME for gesture typing
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/pti/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# Fix Dialer
#PRODUCT_COPY_FILES +=  \
#    vendor/pti/prebuilt/common/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# Pti-specific startup services
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/pti/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/pti/prebuilt/common/bin/sysinit:system/bin/sysinit

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/pti/config/permissions/pti-power-whitelist.xml:system/etc/sysconfig/pti-power-whitelist.xml

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    LockClock \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# Extra Optional packages
PRODUCT_PACKAGES += \
    Calculator \
    LatinIME \
    BluetoothExt \
    Launcher3Dark


# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g


PRODUCT_PACKAGES += \
    charger_res_images

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGES += \
    AndroidDarkThemeOverlay \
    SettingsDarkThemeOverlay

PRODUCT_PACKAGE_OVERLAYS += vendor/pti/overlay/common

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/pti/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then \
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi; \
  fi; \
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip \
    vendor/pti/Memes/*:system/media/Easter-Egg/*
else
PRODUCT_COPY_FILES += \
    vendor/pti/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip \
    vendor/pti/Memes/*:system/media/Easter-Egg/*
endif
endif

PRODUCT_COPY_FILES += \
    vendor/pti/changelog.txt:system/etc/changelog.txt

# Versioning System
PRODUCT_VERSION_MAJOR = Stable
PRODUCT_VERSION_MAINTENANCE = 1.0
PTI_POSTFIX := -$(shell date -u +%Y%m%d)
ifdef PTI_BUILD_EXTRA
    PTI_POSTFIX := -$(PTI_BUILD_EXTRA)
endif

ifndef PTI_BUILD_TYPE
    PTI_BUILD_TYPE := UNOFFICIAL
endif

# Set all versions
PTI_VERSION := PTi-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(PTI_BUILD)-$(PTI_BUILD_TYPE)$(PTI_POSTFIX)
PTI_MOD_VERSION := PTi-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(PTI_BUILD)-$(PTI_BUILD_TYPE)$(PTI_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    pti.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.pti.version=$(PTI_VERSION) \
    ro.modversion=$(PTI_MOD_VERSION) \
    ro.pti.buildtype=$(PTI_BUILD_TYPE)

# Google sounds
include vendor/pti/google/GoogleAudio.mk

EXTENDED_POST_PROCESS_PROPS := vendor/pti/tools/pti_process_props.py

# Google fonts
PRODUCT_COPY_FILES += \
    vendor/pti/fonts/GoogleSans-Regular.ttf:system/fonts/GoogleSans-Regular.ttf \
    vendor/pti/fonts/GoogleSans-Medium.ttf:system/fonts/GoogleSans-Medium.ttf \
    vendor/pti/fonts/GoogleSans-MediumItalic.ttf:system/fonts/GoogleSans-MediumItalic.ttf \
    vendor/pti/fonts/GoogleSans-Italic.ttf:system/fonts/GoogleSans-Italic.ttf \
    vendor/pti/fonts/GoogleSans-Bold.ttf:system/fonts/GoogleSans-Bold.ttf \
    vendor/pti/fonts/GoogleSans-BoldItalic.ttf:system/fonts/GoogleSans-BoldItalic.ttf

# Packages
include vendor/pti/config/packages.mk
