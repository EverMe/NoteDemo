//
//  People.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "People.h"

@implementation People

- (void)eat{
    NSLog(@"People eat");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(peopleRun)]) {
            [self.delegate peopleRun];
        }
    });

}

- (void)see{
    NSLog(@"People see -- %@",self.class);
}

@end
