//
//  GCDTimer.h
//  NoteDemo
//
//  Created by baoyewei on 2019/7/19.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 自定义timer添加场景
typedef  NS_ENUM(NSInteger,TimerActionOption){
    CancelPreviousTimerAction = 0, // 取消上一次timer计时任务
    MergePreviousTimerAction,      // 合并上一次timer计时任务
};


@interface GCDTimerManager : NSObject

// 单例
+ (GCDTimerManager *)manager;


/**
 启动一个timer (默认精度为0.1s)
 @param timerName       timer的名称，作为唯一标识。
 @param interval        执行的时间间隔。
 @param queue           timer将被放入的队列，也就是最终action执行的队列。传入nil将自动放到一个全局子线程队列中。
 @param repeats         timer是否循环调用。
 @param option          多次schedule同一个timer时的操作选项(目前提供将之前的任务废除或合并的选项)。
 @param action          时间间隔到点时执行的block。
 */
- (void)scheduleGCDTimerWithName:(NSString *)timerName
                        interval:(double)interval
                           queue:(dispatch_queue_t)queue
                         repeats:(BOOL)repeats
                          option:(TimerActionOption)option
                          action:(dispatch_block_t)action;

/**
 取消timer
 @param timerName timer的名称，作为唯一标识。
 */
- (void)cancelTimerWithName:(NSString *)timerName;

@end

NS_ASSUME_NONNULL_END




/*** 使用如下:
 创建:
 [GCDTimerManager.manager scheduleGCDTimerWithName:timerName interval:1 queue:dispatch_get_main_queue() repeats:YES option:CancelPreviousTimerAction action:^{
 NSLog(@"%@ xxxx", GCDTimerName);
 }];
 
 销毁:
 [GCDTimerManager.manager  cancelTimerWithName:timerName];
 */
