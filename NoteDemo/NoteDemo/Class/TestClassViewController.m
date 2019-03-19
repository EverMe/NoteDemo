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
    
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[ClassA class] isKindOfClass:[ClassA class]];
    BOOL res4 = [(id)[ClassA class] isMemberOfClass:[ClassA class]];
    
    NSLog(@"%d , %d ,%d ,%d",res1,res2,res3,res4);
    
    /**
     //类对象的class是meta-class  instance的class是类对象
     
     res1: [NSObject class]即 NSObject类对象  object_getClass((id)self)即meta_NSObject
            第一次循环：meta_NSObject != NSObject
            第二次循环: (meta_NSObject的super是NSObject) 相等 return YES
     
     res2: 执行判断 meta_NSObject != NSObject ，return NO
     
     res3: [ClassA class]即ClassA类对象 object_getClass((id)self)即meta_ClassA
            meat_ClassA 最后一次循环是：NSobject != ClassA 所以return NO
     res4: 执行判断 meta_ClassA != ClassA ，return NO
     */
}

/**
 
 + (Class)class {
    return self;
 }
 
 + (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
        if (tcls == cls) return YES;
    }
    return NO;
 }
 
 + (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
 }
 
 Class object_getClass(id obj)
 {
    if (obj) return obj->getIsa();
    else return Nil;
 }
 
 */

@end
