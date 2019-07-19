//
//  TestHookMethodController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestHookMethodController.h"
#import "People.h"
#import "Student+D.h"


//https://blog.csdn.net/qq_34047841/article/details/78467477
//http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/




@interface TestHookMethodController ()<PeopleDelegate>

@end

@implementation TestHookMethodController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    People *p = [People new];
    p.delegate = self;
    [p eat];
}

- (void)peopleRun{
    NSLog(@"Controller peopleRun");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    Student *s = [Student new];
    [s see];
    
    
    
}

@end
