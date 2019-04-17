//
//  SYTimer.h
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYTimer : NSObject

@property (readonly) NSTimeInterval timeInterval;
@property (readonly, getter=isValid) BOOL valid;
@property (nullable, readonly, retain) id userInfo;
@property (copy) NSDate *fireDate;

@property (nonatomic, copy) NSString *runLoopMode;


/** target-action 创建timer */
+ (SYTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
+ (SYTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/** block 创建timer */
+ (SYTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(SYTimer *timer))block;
+ (SYTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(SYTimer *timer))block;

/** 通过timerXXX方法生成的timer 需要手动启动定时器 */
- (void)fire;
- (void)fireNow;

/** 使timer失效 */
- (void)invalidate;

/** 暂停timer */
- (void)pause;
/** 恢复timer */
- (void)resume;


@end

NS_ASSUME_NONNULL_END
