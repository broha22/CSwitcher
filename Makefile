include theos/makefiles/common.mk
export ARCHS = armv7 armv7s arm64
export SDKVERSION = 7.1
expot DEBUG = 1
TWEAK_NAME = CSwitcher

CSwitcher_FILES = Tweak.xm CSView-New.xm CSIconDelegate.xm CSContainer.xm
CSwitcher_FRAMEWORKS = Foundation UIKit CoreGraphics CoreImage QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += cswitcherprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
