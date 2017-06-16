//
//  NavSetVC1ViewController.m
//  TestUIViewController
//
//  Created by baoyewei on 2017/5/23.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "NavSetVC1ViewController.h"
#import "NavSetVC2ViewController.h"

@interface NavSetVC1ViewController ()

@end

@implementation NavSetVC1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =  CGRectMake(100, 100, 200, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"VC1--PushVC2" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}

- (void)push{
    
    NavSetVC2ViewController *vc2 = [NavSetVC2ViewController new];
    [self.navigationController pushViewController:vc2 animated:YES];
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
