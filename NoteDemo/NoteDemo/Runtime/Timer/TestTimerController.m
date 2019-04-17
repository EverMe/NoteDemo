//
//  TestTimerController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/17.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestTimerController.h"
#import "SYTimer.h"

@interface TestTimerController ()

@property (nonatomic, strong) SYTimer *timer;

@end

@implementation TestTimerController{
    
    NSInteger _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _count = 0;
    
    NSLog(@"before timer");
    self.timer = [SYTimer timerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
//    __weak __typeof(self) weakSelf = self;
//    self.timer = [SYTimer timerWithTimeInterval:1 repeats:YES block:^(SYTimer * _Nonnull timer) {
//        [weakSelf timerRun];
//    }];
    [self.timer fire];
}

- (void)timerRun{
    NSLog(@"count-%ld",_count++);
}
- (IBAction)pause:(id)sender {
     [self.timer pause];
}
- (IBAction)resume:(id)sender {
    [self.timer resume];
}

- (void)dealloc{
    NSLog(@"TestTimerController dealloc");
    [self.timer invalidate];
}

@end
