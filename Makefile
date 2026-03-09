# Makefile

# 保持你原来的设备和编译配置
TARGET = iphone:clang:latest:14.0
ARCHS = arm64 arm64e

# 保持你的自动化逻辑
ifeq ($(SCHEME),roothide)
    export THEOS_PACKAGE_SCHEME = roothide
else ifeq ($(SCHEME),rootless)
    export THEOS_PACKAGE_SCHEME = rootless
else
    unexport THEOS_PACKAGE_SCHEME
endif

ifeq ($(GITHUB_ACTIONS),true)
    export INSTALL = 0
    export FINALPACKAGE = 1
endif

export DEBUG = 0

# ██████████████████████████████████████████████████████████████████
# 修改点 1: 修改注入进程名
# 注意：请将 "YourAppProcessName" 改为你实际要注入的 App 进程名
INSTALL_TARGET_PROCESSES = YourAppProcessName
# ██████████████████████████████████████████████████████████████████

include $(THEOS)/makefiles/common.mk

# ██████████████████████████████████████████████████████████████████
# 修改点 2: 定义 TWEAK_NAME
# 这里我假设你希望主程序叫 DYYY，或者你可以改成 GameSpeedHack
# 关键是下面的变量要和这个名称一致
TWEAK_NAME = DYYY

# 修改点 3: 关联你的代码文件
# 这行告诉 Theos：DYYY 这个程序由 Tweak.xm 编译而来
$(TWEAK_NAME)_FILES = Tweak.xm

# 修改点 4: 关联你的配置文件
# 这行告诉 Theos：使用 GameSpeedHack.plist 作为配置
$(TWEAK_NAME)_PACKAGE_TYPE = com.apple越狱 tweak
$(TWEAK_NAME)_INSTALL_PATH = /Library/TweakInject
$(TWEAK_NAME)_EXTRA_FRAMEWORKS = UIKit Foundation
# ██████████████████████████████████████████████████████████████████

include $(THEOS_MAKE_PATH)/tweak.mk

# 保持你原来的安装逻辑
ifeq ($(shell whoami),huami)
    THEOS_DEVICE_IP = 192.168.31.227
else
    THEOS_DEVICE_IP = 192.168.1.202
endif
THEOS_DEVICE_PORT = 22

clean::
    @echo -e "\033[31m==>\033[0m Cleaning packages…"
    @rm -rf .theos packages

after-package::
    @echo -e "\033[32m==>\033[0m Packaging complete."
    @if [ "$(GITHUB_ACTIONS)" != "true" ] && [ "$(INSTALL)" = "1" ]; then \
        DEB_FILE=$(ls -t packages/*.deb | head -1); \
        PACKAGE_NAME=$(basename "$DEB_FILE" | cut -d'_' -f1); \
        echo -e "\033[34m==>\033[0m Installing $PACKAGE_NAME to device…"; \
        ssh root@$(THEOS_DEVICE_IP) "rm -rf /tmp/${PACKAGE_NAME}.deb"; \
        scp "$DEB_FILE" root@$(THEOS_DEVICE_IP):/tmp/${PACKAGE_NAME}.deb; \
        ssh root@$(THEOS_DEVICE_IP) "dpkg -i --force-overwrite /tmp/${PACKAGE_NAME}.deb && rm -f /tmp/
