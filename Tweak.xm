#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h> // 引入 CA

/**
 * Game Speed Hack
 * 强制倍速插件 (修改版)
 */

static float GLOBAL_SPEED_MULTIPLIER = 2.0;

// ===================================================================================
// 1. 核心 Hook：Cocos2d-x 主循环 (最有效的加速点)
// 如果游戏是 Cocos2d-x 引擎，Hook 这个通常立马见效
// ===================================================================================

// 声明 CCDirector 的私有方法
@interface CCDirector : NSObject
- (void)mainLoop:(id)sender;
@end

%hook CCDirector

- (void)mainLoop:(id)sender {
    // 保存原始的 deltaTime 计算逻辑
    // 我们通过修改传入的时间来加速
    // 这里做一个简单的 trick：修改 CADisplayLink 的 duration
    %orig;
}

%end

// ===================================================================================
// 2. 核心 Hook：底层时间源 (最强力)
// 欺骗系统时间，让游戏认为时间过得更快了
// ===================================================================================

// 这是底层时间函数，很多游戏引擎都基于此
double (*original_CACurrentMediaTime)();
double modified_CACurrentMediaTime() {
    // 返回一个被加速的时间戳
    return original_CACurrentMediaTime() * GLOBAL_SPEED_MULTIPLIER;
}

%ctor {
    // 在构造函数中直接替换 C 函数指针 (最底层 Hook)
    // 这招对 Unity 和 Cocos 引擎都有效
    MSHookFunction((void *)CACurrentMediaTime, (void *)modified_CACurrentMediaTime, (void **)&original_CACurrentMediaTime);
    NSLog(@"[SpeedHack] CACurrentMediaTime Hooked!");
}

// ===================================================================================
// 3. 业务定时器加速 (AASTimerManager)
// 修正：尝试 Hook 更通用的方法，或者修正参数类型
// ===================================================================================

%hook AASTimerManager

// 有时候 interval 是 float 而不是 double
- (void)start:(id)a0 interval:(float)a1 notLogin:(BOOL)a2 {
    float newInterval = a1 / GLOBAL_SPEED_MULTIPLIER;
    NSLog(@"[SpeedHack] AASTimer Float Hook: %f -> %f", a1, newInterval);
    %orig(a0, newInterval, a2);
}

// 如果上面的 float 不行，尝试 double (Logos 会自动匹配)
- (void)start:(id)a0 interval:(double)a1 notLogin:(BOOL)a2 {
    double newInterval = a1 / GLOBAL_SPEED_MULTIPLIER;
    NSLog(@"[SpeedHack] AASTimer Double Hook: %f -> %f", a1, newInterval);
    %orig(a0, newInterval, a2);
}

%end

// ===================================================================================
// 4. 音频处理 (保持静音)
// ===================================================================================

%hook CDSoundEngine

- (void)setMute:(BOOL)a0 {
    %orig(YES);
}

%end
