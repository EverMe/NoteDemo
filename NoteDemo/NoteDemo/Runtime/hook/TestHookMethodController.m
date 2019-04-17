//
//  TestHookMethodController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestHookMethodController.h"
#import "People.h"



//https://blog.csdn.net/qq_34047841/article/details/78467477
//http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/




@interface TestHookMethodController ()

@end

@implementation TestHookMethodController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    People *p = [People new];
    [p eat];
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
