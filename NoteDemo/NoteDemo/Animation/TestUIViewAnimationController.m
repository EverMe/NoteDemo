//
//  TestUIViewAnimationController.m
//  NoteDemo
//
//  Created by byw on 2019/2/13.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestUIViewAnimationController.h"


//https://www.jianshu.com/p/9fa025c42261
//https://www.jianshu.com/p/51483b560244
@interface TestUIViewAnimationController ()


@end

@implementation TestUIViewAnimationController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testFrameAndBounds2];
}




- (void)testCAAnimation{
    
    CABasicAnimation *a ;
    
    
}



- (void)animationPause:(CALayer*)layer {
    // 当前时间（暂停时的时间）
    // CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置
    CFTimeInterval pauseTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 停止动画
    layer.speed = 0;
    // 动画的位置（动画进行到当前时间所在的位置，如timeOffset=1表示动画进行1秒时的位置）
    layer.timeOffset = pauseTime;
}
- (void)animationContinue:(CALayer*)layer {
    // 动画的暂停时间
    CFTimeInterval pausedTime = layer.timeOffset;
    // 动画初始化
    layer.speed = 1;
    layer.timeOffset = 0;
    layer.beginTime = 0;
    // 程序到这里，动画就能继续进行了，但不是连贯的，而是动画在背后默默“偷跑”的位置，如果超过一个动画周期，则是初始位置
    // 当前时间（恢复时的时间）
    CFTimeInterval continueTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    // 动画从timePause的位置从动画头开始
    layer.beginTime = timePause;
}

//理解frame和Bounds的区别和意义
- (void)testFrameAndBounds1{
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
    aView.backgroundColor = UIColor.redColor;
    [aView setAutoresizesSubviews:NO];
    [self.view addSubview:aView];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    bView.backgroundColor = UIColor.greenColor;
    //[bView setAutoresizingMask:UIViewAutoresizingNone];
    [aView addSubview:bView];
    
    UIView *cView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    cView.backgroundColor = UIColor.orangeColor;
    //[bView setAutoresizingMask:UIViewAutoresizingNone];
    [bView addSubview:cView];
    
    UIView *dView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 50, 50)];
    dView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:dView];
    
    NSLog(@"befroe----aFrmae:%@ aBounds:%@ \n bFrmae:%@ bBounds:%@ \n cFrmae:%@ cBounds:%@ ",NSStringFromCGRect(aView.frame),NSStringFromCGRect(aView.bounds),NSStringFromCGRect(bView.frame),NSStringFromCGRect(bView.bounds),NSStringFromCGRect(cView.frame),NSStringFromCGRect(cView.bounds));
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
//        aView.transform = CGAffineTransformMakeScale(2.0, 2.0);
//        bView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        aView.transform = CGAffineTransformMakeTranslation(0, 100);
        
        NSLog(@"after-----aFrmae:%@ aBounds:%@ \n bFrmae:%@ bBounds:%@ \n cFrmae:%@ cBounds:%@ ",NSStringFromCGRect(aView.frame),NSStringFromCGRect(aView.bounds),NSStringFromCGRect(bView.frame),NSStringFromCGRect(bView.bounds),NSStringFromCGRect(cView.frame),NSStringFromCGRect(cView.bounds));
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGRect bframe = bView.frame;
            bView.frame = bframe;
            NSLog(@"%@",NSStringFromCGRect(bframe));
        });
    });
    
    
    //更改transform 只会影响当前view的frame 并不会影响其bounds 子view的frame和bounds都不会被影响
    
}

- (void)testFrameAndBounds2{
    
    //更改bounds 只变更x y  view的位置大小不变 frame自然不会变 但xy变化，子view的(0，0)点发生变化 会影响子view的位置但frame和bounds不变
    //更改bounds的size 会导致view大小 位置 frame发生改变 子view同上
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
    aView.backgroundColor = UIColor.redColor;
    [aView setAutoresizesSubviews:NO];
    [self.view addSubview:aView];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    bView.backgroundColor = UIColor.greenColor;
    [aView addSubview:bView];
    
    NSLog(@"before-----aFrmae:%@ aBounds:%@ \n bFrmae:%@ bBounds:%@ ",NSStringFromCGRect(aView.frame),NSStringFromCGRect(aView.bounds),NSStringFromCGRect(bView.frame),NSStringFromCGRect(bView.bounds));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        bView.frame = CGRectMake(0, 0, 50, 50);
        NSLog(@"after1-----aFrmae:%@ aBounds:%@ \n bFrmae:%@ bBounds:%@ ",NSStringFromCGRect(aView.frame),NSStringFromCGRect(aView.bounds),NSStringFromCGRect(bView.frame),NSStringFromCGRect(bView.bounds));
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGRect aBounds = aView.bounds;
            aView.bounds = CGRectMake(50, 50, aBounds.size.width , aBounds.size.height );
            //aView.bounds = CGRectMake(50, 50, aBounds.size.width / 2, aBounds.size.height / 2 );
            
            NSLog(@"after2-----aFrmae:%@ aBounds:%@ \n bFrmae:%@ bBounds:%@ ",NSStringFromCGRect(aView.frame),NSStringFromCGRect(aView.bounds),NSStringFromCGRect(bView.frame),NSStringFromCGRect(bView.bounds));
        });
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
