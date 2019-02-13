//
//  TestUIViewAnimationController.m
//  NoteDemo
//
//  Created by byw on 2019/2/13.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestUIViewAnimationController.h"


//https://www.jianshu.com/p/9fa025c42261
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

    [self testFrameAndBounds];
}




- (void)testCAAnimation{
    
    CABasicAnimation *a ;
    
    
}


//暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

//理解frame和Bounds的区别和意义
- (void)testFrameAndBounds{
    
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
        aView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        bView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        NSLog(@"after-----aFrmae:%@ aBounds:%@ \n bFrmae:%@ bBounds:%@ \n cFrmae:%@ cBounds:%@ ",NSStringFromCGRect(aView.frame),NSStringFromCGRect(aView.bounds),NSStringFromCGRect(bView.frame),NSStringFromCGRect(bView.bounds),NSStringFromCGRect(cView.frame),NSStringFromCGRect(cView.bounds));
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CGRect bframe = bView.frame;
            bView.frame = bframe;
            NSLog(@"%@",NSStringFromCGRect(bframe));
        });
    });
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
