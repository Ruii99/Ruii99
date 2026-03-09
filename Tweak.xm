// Tweak.xm
// Cocos2d-x Game Speed Hack
// Hook 逻辑入口

#import <Foundation/Foundation.h>

// ===================================================================================
// 1. Hook 核心：业务定时器加速 (AASTimerManager)
// 说明：这是最安全且效果最明显的 Hook 点。通过缩短定时器间隔，实现收益、倒计时加速。
// ===================================================================================

// 声明外部函数，用于动态创建类或方法（如果需要）
extern "C" {
    void NSLog(CFStringRef format, ...);
}

// 定义加速倍率 (1.0 为正常速度，2.0 为 2 倍速)
static float GLOBAL_SPEED_MULTIPLIER = 2.0;

%hook AASTimerManager

// 原型: - (void)start:(id)a0 interval:(double)a1 notLogin:(BOOL)a2;
// 功能：拦截定时器启动，将间隔时间除以加速倍率
- (void)start:(id)a0 interval:(double)a1 notLogin:(BOOL)a2 {
    if (a1 > 0) {
        double newInterval = a1 / GLOBAL_SPEED_MULTIPLIER;
        NSLog((CFStringRef)CFSTR("[SpeedHack] Timer: %.2f -> %.2f"), a1, newInterval);
        %orig(a0, newInterval, a2);
    } else {
        %orig;
    }
}

%end

// ===================================================================================
// 2. Hook 核心：Cocos2d-x 渲染循环 (EAGLView)
// 说明：通过 Hook layoutSubviews，尝试拦截主循环。这是画面加速的关键。
// ===================================================================================

%hook EAGLView

// 原型: - (void)layoutSubviews;
// 功能：Cocos2d-x 通常在这里触发 draw 或 mainLoop
- (void)layoutSubviews {
    // 这里比较 tricky。EAGLView 通常会调用一个私有方法或函数来更新逻辑。
    // 由于我们无法直接修改 deltaTime，我们尝试通过控制内部的 timer 来实现。
    // 如果 layoutSubviews 调用了原逻辑，我们先执行它。
    
    // 获取当前时间戳，并尝试修改内部状态
    // 注意：如果 EAGLView 内部使用了 CADisplayLink，我们需要 Hook 那个。
    // 作为备选方案，我们在这里不做处理，转而 Hook CCDirector。
    
    %orig;
}

%end

// ===================================================================================
// 3. Hook 辅助：心跳包管理 (AASHeartBeat)
// 说明：如果游戏逻辑依赖服务器心跳，加速心跳包发送频率。
// 注意：如果 AAS 是防沉迷，请谨慎使用！
// ===================================================================================

%hook AASHeartBeat

// 假设 playtime 是只读属性，我们 Hook 它的 getter 来欺骗服务器（慎用）
- (double)playtime {
    double original = %orig;
    // 返回加速后的时间（仅在读取时生效，视具体逻辑而定）
    return original * GLOBAL_SPEED_MULTIPLIER;
}

// 如果有 update 或 sendHeartbeat 方法，请在这里 Hook
// - (void)update { ... }

%end

// ===================================================================================
// 4. Hook 辅助：RunLoop 监控 (BLYMainRunloopMonitorManager)
// 说明：防止加速导致被 Bugly 误判为卡顿。
// ===================================================================================

%hook BLYMainRunloopMonitorManager

// 原型: - (void)addRunloopObserver;
// 功能：如果加速导致帧时间过长，可能会被监控。我们可以尝试移除监控。
- (void)addRunloopObserver {
    // 什么都不做，或者调用原函数
    // 如果游戏加速后卡顿严重，可以注释掉 %orig 来禁用监控
    // %orig;
    NSLog((CFStringRef)CFSTR("[SpeedHack] BLY Monitor Disabled"));
}

%end

// ===================================================================================
// 5. Hook 辅助：音频引擎 (CDSoundEngine)
// 说明：加速后声音会变调（像小黄人）。这里提供静音方案。
// ===================================================================================

%hook CDSoundEngine

// 原型: - (void)setMute:(BOOL)a0;
// 功能：强制静音，避免声音变调
- (void)setMute:(BOOL)a0 {
    // 强制静音
    %orig(YES);
}

// 如果有播放背景音乐的方法，也可以 Hook
// - (void)playBackgroundMusic:... { ... }

%end
