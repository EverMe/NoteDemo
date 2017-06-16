//
//  LifeCircle2ViewController.m
//  TestUIViewController
//
//  Created by baoyewei on 17/3/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "LifeCircle2ViewController.h"

@interface LifeCircle2ViewController ()

@end

@implementation LifeCircle2ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
    
    NSLog(@"----------------------------------------------------------------------------");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
}

+ (void)load{
    
    [super load];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
}

-(void)dealloc{
    
     NSLog(@"%@--%s",[self class],__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
