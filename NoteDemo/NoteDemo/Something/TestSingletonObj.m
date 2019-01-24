//
//  TestSingletonObj.m
//  NoteDemo
//
//  Created by byw on 2019/1/24.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestSingletonObj.h"

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


@end
