#  GameSpeedHack
#  Copyright (c) 2024. All rights reserved.

-include Makefile.local

# 基础配置
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

# 目标进程 (请根据实际游戏修改，例如：com.speed.game)
INSTALL_TARGET_PROCESSES = com.4399.zmxyol

# 根据参数选择打包方案 (rootless / roothide / rootful)
ifeq ($(SCHEME),roothide)
    export THEOS_PACKAGE_SCHEME = roothide
else ifeq ($(SCHEME),rootless)
    export THEOS_PACKAGE_SCHEME = rootless
else
    unexport THEOS_PACKAGE_SCHEME
endif

# GitHub Actions 环境优化
ifeq ($(GITHUB_ACTIONS),true)
    export INSTALL = 0
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GameSpeedHack

# ！！！这里修改为你实际的文件名！！！
GameSpeedHack_FILES = Tweak.xm
GameSpeedHack_CFLAGS = -fobjc-arc -w
GameSpeedHack_FRAMEWORKS = UIKit Foundation AudioToolbox
GameSpeedHack_LOGOS_DEFAULT_GENERATOR = internal

include $(THEOS_MAKE_PATH)/tweak.mk

# 清理工具
clean::
	@echo -e "\033[31m==>\033[0m Cleaning packages…"
	@rm -rf .theos packages
