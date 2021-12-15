ARCHS = armv7 armv7s arm64 arm64e
THEOS_DEVICE_IP = localhost
LocationSpooferTweak_FRAMEWORKS = CoreLocation
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = LocationSpooferTweak
LocationSpooferTweak_FILES = Tweak.x
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "sbreload; killall -9 locationd"
