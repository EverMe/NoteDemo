//
//  People+C.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "People+C.h"
#import "NSObject+DLIntrospection.h"

@implementation People (C)


+(void)load{
    
    NSLog(@"People C load");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [People swizzleSEL:@selector(eat) withSEL:@selector(c_eat)];
    });
    
}

- (void)c_eat{
    
    NSLog(@"People C eat");
    [self c_eat];
}
@end
