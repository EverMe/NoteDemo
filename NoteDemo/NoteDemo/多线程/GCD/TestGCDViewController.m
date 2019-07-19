//
//  TestGCDViewController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/3/17.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestGCDViewController.h"

//https://www.cnblogs.com/xiubin/p/5885007.html

@interface TestGCDViewController ()

@end

@implementation TestGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)testQueueAndSync{
    
    
    /**
                    并发队列                串行队列（非主队列）    主队列（只有主线程，串行队列）
     同步(sync)     不开启新的线程，串行      不开启新的线程，串行    不开启新的线程，串行
     异步(async)    开启新的线程，并发        开启新的线程，串行     不开启新的线程，串行
     
     sync async 决定是否去线程池拿新线程
     SERIAL CONCURRENT 决定queue能取到几个线程
     
     
     */
    
    //dispatch_sync 不会创建新线程
    
    NSLog(@"0---%@",NSThread.currentThread);
    dispatch_queue_t queue = dispatch_queue_create("com.abc", DISPATCH_QUEUE_SERIAL);
    
//    dispatch_queue_t queue = dispatch_queue_create("com.abc", DISPATCH_QUEUE_CONCURRENT);
    
    
    dispatch_async(queue, ^{
        
        NSLog(@"1---%@",NSThread.currentThread);
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"2---%@",NSThread.currentThread);
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"3---%@",NSThread.currentThread);
    });
}



- (void)testSync{
    
    //同步（sync）和异步（async）的主要区别在于会不会阻塞当前线程，直到Block中的任务执行完毕！
    //如果是同步（sync）操作，它会阻塞当前线程并等待Block中的任务执行完毕，然后当前线程才会继续往下运行。
    //如果是异步（async）操作，当前线程会直接往下执行，它不会阻塞当前线程
    
    //Calling this function and targeting the current queue results in deadlock.
    //dispatch_sync 当前执行队列与提交block执行的目标队列相同时将造成死锁。
    
    //    dispatch_queue_t queue = dispatch_queue_create("com.testSync", DISPATCH_QUEUE_SERIAL);        //死锁
    dispatch_queue_t queue = dispatch_queue_create("com.testSync", DISPATCH_QUEUE_CONCURRENT);      //可执行
    //    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);                                     //可执行
    dispatch_async(queue, ^{
        
        NSLog(@"000");
        dispatch_sync(queue, ^{
            
            NSLog(@"111");
            NSLog(@"1-%@",[NSThread currentThread]);
            dispatch_sync(queue, ^{
                NSLog(@"2-%@",[NSThread currentThread]);
                NSLog(@"222");
                sleep(1);
            });
//            NSLog(@"333");
//            dispatch_async(queue, ^{
//                NSLog(@"444");
//            });
//            sleep(1);
            NSLog(@"555");
            
        });
        NSLog(@"666");
        
    });
    
    /**
     个人理解：
     dispatch_async本身可看作taskA taskA的作用是把taskB放到指定队列中执行，并且执行完毕后，taskA才算执行完毕。
     
     串行队列中，只有一个线程，当在执行taskA时，由于taskA需要taskB执行完毕才可继续执行，但taskB的执行需要在taskA完成后才能执行，
     taskA taskB 互相等待，造成死锁。
     
     并发队列中，可以有多个线程，当taskA把taskB放到队列中后，taskA开始等待taskB的完成，
     并发队列 导致taskB可以被执行，taskB执行完，taskA继续执行
     */
#warning 并发中1.2两个线程是同一个 这点还没想太明白???????
}

//Semaphore 实现锁的两种方式
- (void)testSemaphore{
    //1.实现锁
    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
    for (NSInteger i = 0; i < 10; i++){
        
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%ld", i);
            dispatch_semaphore_signal(lock);
        });
    }
    
    /**
     执行过程：创建信号量 初始值为1(相当于剩余车位1)
     执行i=0，上来就wait (信号量-1 刚好可以停下) 继续执行异步
     由于是异步 继续循环i=1 上来再wait 发现此时信号量已经为0 所以需要等待上次异步执行完signal后 才能继续执行
     */
    
    
    //2.
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    dispatch_queue_t queue = dispatch_queue_create("groupBlock", NULL);
//    dispatch_async(queue, ^{
//        /*
//         code
//         */
//        dispatch_semaphore_signal(semaphore);
//    });
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"end");
    
    /**
     
     执行过程：创建信号量 初始值为0(相当于没有剩余车位) 但没遇到wait前都可继续执行
     创建queue执行异步任务 同时遇到了wait 所以等待异步signal 才能执行log
     */
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self testSemaphore];

    //[self testQueueAndSync];
    [self performSelectorInBackground:@selector(testQueueAndSync) withObject:nil];
}

@end
