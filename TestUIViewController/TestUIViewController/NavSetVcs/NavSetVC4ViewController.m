//
//  NavSetVC4ViewController.m
//  TestUIViewController
//
//  Created by baoyewei on 2017/5/23.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "NavSetVC4ViewController.h"
#import "NavSetVC2ViewController.h"

@interface NavSetVC4ViewController ()

@end

@implementation NavSetVC4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =  CGRectMake(100, 100, 200, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"VC4--PushVC2" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)push{
    
    NavSetVC2ViewController *vc2;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NavSetVC2ViewController class]]) {
            vc2 = (NavSetVC2ViewController *)vc;
        }
    }
    
    if (!vc2) {
        vc2 = [NavSetVC2ViewController new];
        [self.navigationController pushViewController:vc2 animated:YES];
    }else{
        
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [vcs removeObject:vc2];
        [self.navigationController setViewControllers:vcs animated:NO];
        [self.navigationController pushViewController:vc2 animated:YES];
    }
    
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
