//
//  People+A.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "People+A.h"
#import "NSObject+DLIntrospection.h"

@implementation People (A)

+(void)load{
    
    
    NSLog(@"People A load");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [People swizzleSEL:@selector(eat) withSEL:@selector(a_eat)];
    });
    
    
}

- (void)a_eat{
    
    NSLog(@"People A eat");
    [self a_eat];
}

@end
