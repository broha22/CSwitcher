export TARGET := iphone:7.0:10.0
export ARCHS := armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = CSwitcher
CSwitcher_FILES = Tweak.xm
CSwitcher_FRAMEWORKS = UIKit QuartzCore CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
