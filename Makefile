# Makefile
# Theos 项目构建脚本

# 目标 SDK 和架构
export ARCHS = arm64
export TARGET = iphone:latest:11.0

# 项目名称 (必须与 .xm 文件名一致)
THEOS_DEVICE_IP = 192.168.1.100 # 可选：你的设备 IP
TWEAK_NAME = GameSpeedHack

# 源文件
$(TWEAK_NAME)_SOURCES = Tweak.xm

# 依赖的框架 (Cocos2d-x 通常需要这些)
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation OpenGLES QuartzCore CoreGraphics AudioToolbox

# 附加链接库 (如果需要)
$(TWEAK_NAME)_LIBRARIES = c++

# 安装路径 (通常放在 /Library/MobileSubstrate/DynamicLibraries)
GameSpeedHack_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

# 包含头文件的路径 (如果你有额外的头文件)
# export IPHONEOS_DEPLOYMENT_TARGET = 11.0

include $(THEOS)/makefiles/common.mk

# 编译目标
after-install::
ifeq ($(wildcard $(THEOS_DEVICE_IP)),)
@echo "No device IP set. Please set THEOS_DEVICE_IP in Makefile or environment."
else
@echo "Installing to $(THEOS_DEVICE_IP)..."
scp -r $(THEOS_OBJ_DIR)/GameSpeedHack.dylib root@$(THEOS_DEVICE_IP):/Library/MobileSubstrate/DynamicLibraries/
ssh root@$(THEOS_DEVICE_IP) uicache; killall -9 SpringBoard
endif
