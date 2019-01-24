//
//  TestClassViewController.m
//  NoteDemo
//
//  Created by byw on 2019/1/22.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestClassViewController.h"
#import "ClassB.h"

@interface TestClassViewController ()

@end

@implementation TestClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self test];
    
}


- (void)test{
    
    ClassB *b = [[ClassB alloc] init];
    [b testClass1];
    [b testClass2];
}


@end
