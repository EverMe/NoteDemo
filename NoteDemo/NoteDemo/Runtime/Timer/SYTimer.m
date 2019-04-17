//
//  SYTimer.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "SYTimer.h"

//https://www.jianshu.com/p/76de8b963353
//自定义类(不引入三方) 用于解决NSTimer的循环引用不释放问题 / 系统Timer-block的API(block可以weakSelf不会循环引用) 但只支持ios10以上
//其他解决方案如: YYWeakProxy / YYTimer / NSTimer(YYAdd)提供的block形式

@interface SYTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation SYTimer
@dynamic valid;
@dynamic userInfo;
@dynamic timeInterval;
@dynamic fireDate;

+ (SYTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    
    SYTimer *timer = [[SYTimer alloc] init];
    timer.target = aTarget;
    timer.selector = aSelector;
    timer.timer = [NSTimer timerWithTimeInterval:ti target:timer selector:@selector(timerRunSelector:) userInfo:userInfo repeats:yesOrNo];
    timer.runLoopMode = NSDefaultRunLoopMode;
    return timer;
}
+ (SYTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    
    SYTimer *timer = [SYTimer timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    [timer fire];
    return timer;
}

+ (SYTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(SYTimer *timer))block{
    
    SYTimer *timer = [[SYTimer alloc] init];
    timer.timer = [NSTimer timerWithTimeInterval:interval target:timer selector:@selector(timerRunBlock:) userInfo:[block copy] repeats:repeats];
    timer.runLoopMode = NSDefaultRunLoopMode;
    return timer;
}
+ (SYTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(SYTimer *timer))block{
    
    SYTimer *timer = [SYTimer timerWithTimeInterval:interval repeats:repeats block:block];
    [timer fire];
    return timer;
}


- (void)timerRunSelector:(NSTimer *)timer{
    
    if (self.timer.isValid) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.userInfo];
#pragma clang diagnostic pop
    }else{
        [self invalidate];
    }
}
- (void)timerRunBlock:(NSTimer *)timer{

    if (self.timer.isValid && [timer userInfo]) {
        void (^block)(SYTimer *timer) = (void (^)(SYTimer *timer))[timer userInfo];
        block(self);
    }else{
        [self invalidate];
    }
}

- (void)fire{
    
    if (!self.timer.isValid) {
        return;
    }
    
    if (![self isScheduled]) {
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:self.runLoopMode];
    }
}
- (void)fireNow{
    [self fire];
    [self.timer fire];
}

- (void)invalidate{
    
    self.target = nil;
    self.selector = nil;
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)pause{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resume{
    [self.timer setFireDate:[NSDate date]];
}

- (BOOL)isScheduled
{
    if (!self.timer) {
        return NO;
    }
    
    CFRunLoopRef runLoopRef = [[NSRunLoop currentRunLoop] getCFRunLoop];
    CFArrayRef arrayRef = CFRunLoopCopyAllModes(runLoopRef);
    CFIndex count = CFArrayGetCount(arrayRef);
    
    for (CFIndex i = 0; i < count; ++i) {
        CFStringRef runLoopMode = CFArrayGetValueAtIndex(arrayRef, i);
        if (CFRunLoopContainsTimer(runLoopRef, (__bridge CFRunLoopTimerRef)self.timer, runLoopMode)) {
            CFRelease(arrayRef);
            return YES;
        }
    }
    
    CFRelease(arrayRef);
    return NO;
}


- (BOOL)isValid{
    return self.timer.isValid;
}
- (id)userInfo{
    return self.timer.userInfo;
}
- (NSTimeInterval)timeInterval{
    return self.timer.timeInterval;
}
- (void)setFireDate:(NSDate *)fireDate{
    [self.timer setFireDate:fireDate];
}
- (NSDate *)fireDate{
    return self.timer.fireDate;
}

- (void)dealloc{
    [self invalidate];
    NSLog(@"SYTimer dealloc");
}

@end
