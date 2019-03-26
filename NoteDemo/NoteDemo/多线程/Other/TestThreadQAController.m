//
//  TestThreadQAController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/3/21.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestThreadQAController.h"

@interface TestThreadQAController ()
@property (atomic, strong) NSMutableArray *arr;
@end

@implementation TestThreadQAController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self testPropertyAtomic];
}


- (void)testPropertyAtomic{
    
    self.arr = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
        for (int i=0; i<2 ; i++) {
            [self.arr addObject:@1];
        }
        NSLog(@"1-%@",self.arr);
        
        
    });
    
    dispatch_async(queue, ^{
        
        for (int i=0; i<2 ; i++) {
            [self.arr addObject:@2];
        }
        NSLog(@"2-%@",self.arr);
    });
    
//    dispatch_async(queue, ^{
//
//        for (int i=0; i<2 ; i++) {
//            [self.arr addObject:@3];
//        }
//        NSLog(@"3-%@",self.arr);
//    });
//
//
//    dispatch_async(queue, ^{
//
//        for (int i=0; i<2 ; i++) {
//            [self.arr addObject:@4];
//        }
//        NSLog(@"4-%@",self.arr);
//    });
    
    
    /**
     http://www.cocoachina.com/bbs/read.php?tid-1720812-page-5.html
     atomic的职责是保证读取修饰的变量/指针的安全性，只能保证多线程下，“先后”正确的读写指针地址（setter getter中加锁）
     
     假如说一个8字节指针地址，0x12345678 要给它写入0x00000000
     假设写到了前几位后另外一个线程读取了这个指针的内容，有可能读到的是0x00005678（还没写完），然后继续写的线程才走完
     边读边写就有可能导致，读出来的数据并非是正确的数据
     而atomic的意义就在于此，0x00000000写完之前，读线程是无法读取的，同样的道理，在读线程正在读的过程中，写线程是无法改变8字节的
     
     而网上说的atomic的不安全是针对指针指向的内容在多线程下的操作是非线程安全的，是一种不严谨的说法，容易误导别人。
     网上举例多个线程读写，无法保证顺序，最后读取的值可能是任意一个，要自己加锁，其实和atomic无关，
     aotmic怎么能保证线程的执行顺序呢，又要怎么加锁来解决线程的执行顺序呢？
     
     比如说一个@property（atomic）NSMutableArray *arr； （count=1）
     一个线程在读取第一个值，另外一个线程在写removeAllObjects 如果先执行了remove再读取导致crash
     但是这跟atomic已经没关系了，是对atomic修饰的指针指向的内容进行操作
     
     解决上述问题时，多线程下采用加锁
     平常使用nonatomic的原因时，都是在同一个线程(主线程)中进行的操作，相当于同步操作，是有序的，所以没出现问题。
     */
    
}

@end
