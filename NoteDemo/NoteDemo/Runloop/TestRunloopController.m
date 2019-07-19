//
//  TestRunloopController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/3/17.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestRunloopController.h"

@interface TestRunloopController ()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation TestRunloopController{
    
    NSInteger _num ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _num = 1;
    
    [self addRunloopObserver];
}

//手动停止runloop
- (void)stopRunloop{
    
    //https://www.jianshu.com/p/24f875775336    //三种启动RunLoop方式
    //https://www.jianshu.com/p/8e6d51f69ca3    //手动停止runloop
    
    CFRunLoopStop([NSRunLoop currentRunLoop].getCFRunLoop);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.创建常驻线程 : 开启自线程的Runloop
//    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(createAliveChildThread) object:nil];
//    [self.thread start];

    //2.
    
}


- (void)create{
    
    
    
}


//1.创建常驻线程 : 开启自线程的Runloop
- (void)createAliveChildThread{
    
    NSLog(@"%s",__func__);
    
    /**常驻线程：给子线程开启一个RunLoop
     注意：子线程执行完操作之后就会立即释放，即使我们使用强引用引用子线程使子线程不被释放，也不能给子线程再次添加操作，或者再次开启。
     
     RunLoop中要至少有一个Timer或一个Source 保证RunLoop不会因为空转而退出，因此在创建的时候直接加入，
     如果没有加入Timer或者Source，或者只加入一个监听者 将会无效
     */
    
    [[NSThread currentThread] setName:[NSString stringWithFormat:@"abc-%ld",_num++]];
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(test) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self addRunloopObserver];
}

- (void)addRunloopObserver{
    //kCFRunLoopAllActivities
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopBeforeWaiting, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        if (CFRunLoopGetCurrent() ==  CFRunLoopGetMain() ) {
            NSLog(@"********MainLoop********");
        }
        
        
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;
                
            default:
                break;
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
//    [[NSRunLoop currentRunLoop] run];
    CFRelease(observer);
    
}


- (IBAction)btnclick:(id)sender {
    
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)test{
    
    NSLog(@"%@",[NSThread currentThread]);
}

@end
