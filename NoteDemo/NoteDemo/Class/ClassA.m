//
//  ClassA.m
//  NoteDemo
//
//  Created by byw on 2019/1/22.
//  Copyright © 2019 byw. All rights reserved.
//

#import "ClassA.h"

@implementation ClassA

- (Class)getMyClass{
    NSLog(@"AAAAA");
    return [self class];
}

@end
