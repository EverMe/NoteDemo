//
//  NavSetVC3ViewController.m
//  TestUIViewController
//
//  Created by baoyewei on 2017/5/23.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "NavSetVC3ViewController.h"
#import "NavSetVC4ViewController.h"

@interface NavSetVC3ViewController ()

@end

@implementation NavSetVC3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =  CGRectMake(100, 100, 200, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"VC3--PushVC4" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)push{
    
    NavSetVC4ViewController *vc4 = [NavSetVC4ViewController new];
    [self.navigationController pushViewController:vc4 animated:YES];
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
