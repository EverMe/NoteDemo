//
//  People+B.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "People+B.h"
#import "NSObject+DLIntrospection.h"

@implementation People (B)

+(void)load{
    
    NSLog(@"People B load");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [People swizzleSEL:@selector(eat) withSEL:@selector(b_eat)];
    });
    
}

- (void)b_eat{
    
    NSLog(@"People B eat");
    [self b_eat];
}

@end
