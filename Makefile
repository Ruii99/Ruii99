#
#  DYYY
#
#  Copyright (c) 2024 huami. All rights reserved.
#  Channel: @huamidev
#  Created on: 2024/10/04
#
# 本地配置文件（可选）
-include Makefile.local

# --- 核心配置修改区 ---
# 保持你的目标配置不变
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

# 保持你的调试/安装配置
#export THEOS=/Users/huami/theos
#export THEOS_PACKAGE_SCHEME=roothide

# 根据参数选择打包方案
ifeq ($(SCHEME),roothide)
    export THEOS_PACKAGE_SCHEME = roothide
else ifeq ($(SCHEME),rootless)
    export THEOS_PACKAGE_SCHEME = rootless
else
    unexport THEOS_PACKAGE_SCHEME
endif

# 在GitHub Actions中运行时的特殊配置
ifeq ($(GITHUB_ACTIONS),true)
    export INSTALL = 0
    export FINALPACKAGE = 1
endif

export DEBUG = 0

# ██████████████████████████████████████████████████████████████████
# 修改点 1: 修改注入进程名
# 将这里的 "Aweme" 改成你要加速的游戏进程名 (比如 "WeChat", "PUBG", 或者你的游戏名)
INSTALL_TARGET_PROCESSES = Aweme 
# ██████████████████████████████████████████████████████████████████

# --- Theos 模块包含 ---
include $(THEOS)/makefiles/common.mk

# ██████████████████████████████████████████████████████████████████
# 修改点 2: 修改 Tweak 名称
# 这里的名称必须和你创建的 .xm 文件前缀一致
TWEAK_NAME = Tweak

# 修改点 3: 指定源文件
# 假设你的 Hook 代码写在 Tweak.xm 中
xiamu_FILES = Tweak.xm 

# 修改点 4: 链接必要的框架
# 加速通常需要操作音频（静音）和基础 UI，这里保留了你的配置并增加了 UIKit/Foundation
xiamu_LDFLAGS = -weak_framework AVFAudio
xiamu_FRAMEWORKS = CoreAudio UIKit Foundation OpenGLES QuartzCore

# C++ 标准 (保持不变)
CXXFLAGS += -std=c++11
CCFLAGS += -std=c++11

# Logos 配置
xiamu_LOGOS_DEFAULT_GENERATOR = internal
# ██████████████████████████████████████████████████████████████████

export THEOS_STRICT_LOGOS=0
export ERROR_ON_WARNINGS=0
export LOGOS_DEFAULT_GENERATOR=internal

# --- 编译规则 ---
include $(THEOS_MAKE_PATH)/tweak.mk

# --- 设备配置 ---
# 保持你的设备 IP 配置不变
ifeq ($(shell whoami),huami)
    THEOS_DEVICE_IP = 192.168.31.227
else
    THEOS_DEVICE_IP = 192.168.1.202
endif
THEOS_DEVICE_PORT = 22

# --- 清理与安装 Hook ---
clean::
@echo -e "\033[31m==>\033[0m Cleaning packages…"
@rm -rf .theos packages

# 编译并自动安装
after-package::
@echo -e "\033[32m==>\033[0m Packaging complete."
@if [ "$(GITHUB_ACTIONS)" != "true" ] && [ "$(INSTALL)" = "1" ]; then \
DEB_FILE=$(ls -t packages/*.deb | head -1); \
PACKAGE_NAME=$(basename "$DEB_FILE" | cut -d'_' -f1); \
echo -e "\033[34m==>\033[0m Installing $PACKAGE_NAME to device…"; \
ssh root@$(THEOS_DEVICE_IP) "rm -rf /tmp/${PACKAGE_NAME}.deb"; \
scp "$DEB_FILE" root@$(THEOS_DEVICE_IP):/tmp/${PACKAGE_NAME}.deb; \
ssh root@$(THEOS_DEVICE_IP) "dpkg -i --force-overwrite /tmp/${PACKAGE_NAME}.deb && rm -f /tmp/
