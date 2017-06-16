//
//  ViewController.m
//  TestSummary
//
//  Created by baoyewei on 17/3/28.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "ViewController.h"
#import "Summary.h"
#import "UIButton+Block.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSInteger num = addNum(10, 20);
    NSLog(@"------%ld-----",num);
    
}



- (void)test{
    
    
    NSArray *arr = @[@"1",@"3",@"5",@"10"];
    NSMutableArray *btnArr = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i*50, 40, 40);
        btn.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:btn];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btnArr addObject:btn];
    }
    
    
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
//    dispatch_group_async(group, queue, ^{
        // 循环上传数据
    
        for (int i = 0; i < arr.count; i++) {
            
            dispatch_async(queue, ^{
                //创建dispatch_semaphore_t对象
                NSLog(@"before--%d",i);
                
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                
                UIButton *btn =btnArr[i];
                [btn addBlockForTouchUpInside:^{
                     dispatch_semaphore_signal(semaphore);
                }];
                
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                NSLog(@"after--%d",i);
            });
        
        }
//    });
    
    // 当所有队列执行完成之后
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        // 执行下面的判断代码
        //        if (state == self.goodsArray.count) {
        //            // 返回主线程进行界面上的修改
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                …….
        //            });
        //        }else{
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                …..
        //            });
        //        }
        
        NSLog(@"end");
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
