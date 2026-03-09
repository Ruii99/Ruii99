ARCHS = arm64
TARGET = iphone:latest:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GameSpeedHack

GameSpeedHack_FILES = Tweak.xm
GameSpeedHack_FRAMEWORKS = UIKit Foundation QuartzCore CoreGraphics OpenGLES AudioToolbox
GameSpeedHack_LIBRARIES = c++

include $(THEOS_MAKE_PATH)/tweak.mk