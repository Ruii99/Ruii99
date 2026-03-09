#import <Foundation/Foundation.h>

/**
 * Game Speed Hack
 * 基于 AASTimerManager 与系统组件的倍速插件
 */

// ===================================================================================
// 1. 全局配置
// ===================================================================================
static float GLOBAL_SPEED_MULTIPLIER = 2.0;

// ===================================================================================
// 2. Hook 核心：业务定时器加速 (AASTimerManager)
// ===================================================================================
%hook AASTimerManager

- (void)start:(id)a0 interval:(double)a1 notLogin:(BOOL)a2 {
    if (a1 > 0) {
        double newInterval = a1 / GLOBAL_SPEED_MULTIPLIER;
        // 标准 Objective-C 字符串使用 @""
        NSLog(@"[SpeedHack] Timer adjusted: %.2f -> %.2f", a1, newInterval);
        %orig(a0, newInterval, a2);
    } else {
        %orig;
    }
}

%end

// ===================================================================================
// 3. Hook 辅助：心跳包管理 (AASHeartBeat)
// ===================================================================================
%hook AASHeartBeat

- (double)playtime {
    double original = %orig;
    // 返回加速后的虚假时间，视具体逻辑而定
    return original * (double)GLOBAL_SPEED_MULTIPLIER;
}

%end

// ===================================================================================
// 4. Hook 辅助：RunLoop 监控 (BLYMainRunloopMonitorManager)
// 防止 Bugly 监测到帧率异常导致的误报
// ===================================================================================
%hook BLYMainRunloopMonitorManager

- (void)addRunloopObserver {
    NSLog(@"[SpeedHack] BLY Monitor Disabled to prevent lag detection.");
    // 直接拦截，不调用 %orig 则不启动监控
    // %orig; 
}

%end

// ===================================================================================
// 5. Hook 辅助：音频引擎 (CDSoundEngine)
// ===================================================================================
%hook CDSoundEngine

- (void)setMute:(BOOL)a0 {
    // 强制静音，防止倍速导致的音频变调（小黄人音效）
    %orig(YES);
}

%end
