//
//  GCDTimer.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/19.
//  Copyright © 2019 byw. All rights reserved.
//

#import "GCDTimerManager.h"

//https://blog.csdn.net/dragongd/article/details/61003428
//https://www.jianshu.com/p/6257361716fd
// : 未加锁的疑虑: 后续可参考YYTimer实现

@interface GCDTimerManager ()

@property (nonatomic, strong) NSMutableDictionary *timerDic;
@property (nonatomic, strong) NSMutableDictionary *actionDic;
@end

@implementation GCDTimerManager

+ (GCDTimerManager *)manager{
    
    static GCDTimerManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

// 创建GCDTimer
- (void)scheduleGCDTimerWithName:(NSString *)timerName
                        interval:(double)interval
                           queue:(dispatch_queue_t)queue
                         repeats:(BOOL)repeats
                          option:(TimerActionOption)option
                          action:(dispatch_block_t)action
{
    if (nil == timerName)
        return;
    
    // timer将被放入的队列queue，也就是最终action执行的队列。传入nil将自动放到一个全局子线程队列中
    if (nil == queue)
    {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    // 创建dispatch_source_t的timer
    dispatch_source_t timer = [self.timerDic objectForKey:timerName];
    
    if (nil == timer)
    {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerDic setObject:timer forKey:timerName];
    }
    
    // 设置首次执行事件、执行间隔和精确度(默认为0.1s)
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak __typeof(self) weakSelf = self;
    if(option == CancelPreviousTimerAction) // 取消上一次timer任务
    {
        // 移除上一次任务
        [self removeActionCacheForTimer:timerName];
        
        // 时间间隔到点时执行block
        dispatch_source_set_event_handler(timer, ^{
            
            action();
            
            if (!repeats) {
                [weakSelf cancelTimerWithName:timerName];
            }
        });
        
    }
    else if (option == MergePreviousTimerAction) // 合并上一次timer任务
    {
        // 缓存本次timer任务
        [self cacheAction:action forTimer:timerName];
        
        // 时间间隔到点时执行block
        dispatch_source_set_event_handler(timer, ^{
            
            NSMutableArray *actionArray = [self.actionDic objectForKey:timerName];
            
            [actionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                dispatch_block_t actionBlock = obj;
                actionBlock();
            }];
            
            [weakSelf removeActionCacheForTimer:timerName];
            
            if (!repeats) {
                [weakSelf cancelTimerWithName:timerName];
            }
        });
    }
}

// 取消timer
- (void)cancelTimerWithName:(NSString *)timerName
{
    dispatch_source_t timer = [self.timerDic objectForKey:timerName];
    
    if (!timer)
        return;
    
    [self.timerDic removeObjectForKey:timerName];
    [self.actionDic removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}


#pragma mark - private method
- (void)cacheAction:(dispatch_block_t)action forTimer:(NSString *)timerName
{
    id actionArray = [self.actionDic objectForKey:timerName];
    
    if (actionArray && [actionArray isKindOfClass:[NSMutableArray class]])
    {
        [(NSMutableArray *)actionArray addObject:action];
    }
    else
    {
        NSMutableArray *array = [NSMutableArray arrayWithObject:action];
        [self.actionDic setObject:array forKey:timerName];
    }
}

- (void)removeActionCacheForTimer:(NSString *)timerName
{
    if (![self.actionDic objectForKey:timerName])
        return;
    
    [self.actionDic removeObjectForKey:timerName];
}

- (NSMutableDictionary *)timerDic{
    if (!_timerDic) {
        _timerDic = [NSMutableDictionary new];
    }
    return _timerDic;
}

- (NSMutableDictionary *)actionDic{
    if (!_actionDic) {
        _actionDic = [NSMutableDictionary new];
    }
    return _actionDic;
}


@end
