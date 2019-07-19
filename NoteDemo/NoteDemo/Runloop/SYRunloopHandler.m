//
//  SYRunloopHandler.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/19.
//  Copyright © 2019 byw. All rights reserved.
//

#import "SYRunloopHandler.h"

//Runloop实用篇一 ： 优化tableview列表 监听beforeWaiting时执行 耗时任务
//https://www.jianshu.com/p/04aed74b8309
@interface SYRunloopHandler (){
    
    //初始化方法中开启一个timer，保证Runloop一直在循环。否则监听到Runloop进入休眠的状态时，我们的代码执行过一次后Runloop就进入休眠了
    //https://github.com/chriseleee/load_big_image 不需要timer也可 demo中使用的commomMode
    //NSTimer *_timer;
}

@property (nonatomic, strong) NSMutableArray *freeTasksArray;
@end


@implementation SYRunloopHandler

+ (instancetype)shareHandler{
    
    static SYRunloopHandler *handler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerFiredMethod) userInfo:nil repeats:YES];
        [self runloopBeforeWaiting];
    }
    return self;
}

- (void)addTask:(void(^)(void))task{
    
    if (task) {
        [self.freeTasksArray addObject:task];
    }
}

- (void)runloopBeforeWaiting {
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        if (self.freeTasksArray.count == 0) {
            return;
        }
        // 取出耗性能的任务
        void(^task)(void) = self.freeTasksArray.lastObject;
        // 执行任务
        task();
        // 第一个任务出队列
        [self.freeTasksArray removeLastObject];
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    CFRelease(observer);
}

- (void)timerFiredMethod{
    
    
}


- (NSMutableArray *)freeTasksArray{
    if (!_freeTasksArray) {
        _freeTasksArray = [NSMutableArray new];
    }
    return _freeTasksArray;
}



@end
