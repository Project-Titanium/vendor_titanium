# Versioning System
TITANIUM_BASE_VERSION = v1.0

ifndef TITANIUM_BUILD_TYPE
    TITANIUM_BUILD_TYPE := UNOFFICIAL
endif

# Only include Updater for official builds
#ifeq ($(filter-out OFFICIAL WEEKLIES NIGHTLY,$(TITANIUM_BUILD_TYPE)),)
#    PRODUCT_PACKAGES += \
#        TITANIUM-Updater
#endif

# Sign builds if building an official or weekly build
ifeq ($(filter-out OFFICIAL WEEKLIES,$(TITANIUM_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(KEYS_LOCATION)
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
TITANIUM_VERSION := Titanium-$(TITANIUM_BASE_VERSION)-$(TARGET_PRODUCT)-$(TITANIUM_BUILD_TYPE)-$(BUILD_DATE)-$(BUILD_TIME)
TARGET_BACON_NAME := $(TITANIUM_VERSION)
ROM_FINGERPRINT := Titanium/$(PLATFORM_VERSION)/$(TITANIUM_BUILD_TYPE)/$(BUILD_DATE)$(BUILD_TIME)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.titanium.version=$(TITANIUM_VERSION) \
    ro.mod.version=$(TITANIUM_BUILD_TYPE)-$(TITANIUM_BASE_VERSION)-$(BUILD_DATE) \
    ro.titanium.fingerprint=$(ROM_FINGERPRINT)
