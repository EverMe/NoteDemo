//
//  TestGCDViewController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/3/17.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestGCDViewController.h"

@interface TestGCDViewController ()

@end

@implementation TestGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (void)testSemaphore{
    //1.实现锁
    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
    for (NSInteger i = 0; i < 10; i++){
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%d", i);
            dispatch_semaphore_signal(lock);
        });
    }
    
    //2.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self testSemaphore];
}

@end
