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
    
    
    ClassA *a = [[ClassA alloc] init];
    [self testSelfAndSuper];
    
    [self testIsKindOfClass];
}

//Self Super Class isa的概念
- (void)testSelfAndSuper{
    
    ClassB *b = [[ClassB alloc] init];
    [b testClass1];
    [b testClass2];
}

//isKindOfClass:确定一个对象是否是一个类的成员,或者是派生自该类的成员. isMemberOfClass:确定一个对象是否是当前类的成员.
- (void)testIsKindOfClass{
    //https://www.jianshu.com/p/04f84472c1b8
    //https://www.jianshu.com/p/3bbd81ff35c3
    
    //类对象的class是meta-class
    //instance的class是类对象

    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[ClassA class] isKindOfClass:[ClassA class]];
    BOOL res4 = [(id)[ClassA class] isMemberOfClass:[ClassA class]];
    
    NSLog(@"%d , %d ,%d ,%d",res1,res2,res3,res4);
}

@end
