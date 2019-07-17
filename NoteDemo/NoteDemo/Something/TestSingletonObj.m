//
//  TestSingletonObj.m
//  NoteDemo
//
//  Created by byw on 2019/1/24.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestSingletonObj.h"

//iOS 单例的创建、销毁、继承
//https://www.jianshu.com/p/af7db522388c

@implementation TestSingletonObj


//第一种:
+ (instancetype)sharedSingleton1{
    
    static TestSingletonObj *_instance1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance1 = [[self alloc] _init];
    });
    return _instance1;
}
- (instancetype)_init{
    if (self = [super init]) {
        //......
    }
    return self;
}

//第二种:
//static TestSingletonObj *instance = nil;
//- (instancetype)init{
//    if (self = [super init]) {
//        //......
//    }
//    return self;
//}
//+ (instancetype)sharedSingleton2{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}
//+ (instancetype)allocWithZone:(struct _NSZone *)zone{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [super allocWithZone:zone];
//    });
//    return instance;
//}



//单例的销毁
//+ (void)attempDealloc {
//    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0,这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//    _sharedInstance = nil;
//}


@end
