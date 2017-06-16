//
//  LifeCircle1ViewController.m
//  TestUIViewController
//
//  Created by baoyewei on 17/3/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "LifeCircle1ViewController.h"
#import "LifeCircle2ViewController.h"

@interface LifeCircle1ViewController ()

@end

@implementation LifeCircle1ViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
    
    NSLog(@"-------------------------------------------------------------");
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
    
    [self addPushBtn];
}

-(void)dealloc{
    
    NSLog(@"%@--%s",[self class],__FUNCTION__);
}


- (void)addPushBtn{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pushBtnClick{
    
    LifeCircle2ViewController *vc = [LifeCircle2ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
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
