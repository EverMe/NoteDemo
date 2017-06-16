//
//  UIButton+Block.m
//  TestSummary
//
//  Created by baoyewei on 2017/6/7.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, copy) void (^btnBlock)();

@end

@implementation UIButton (Block)
- (void)addBlockForTouchUpInside:(void (^)())block{
    self.btnBlock = block;
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick{
    if(self.btnBlock){
        self.btnBlock();
    }
}

- (void (^)())btnBlock{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setBtnBlock:(void (^)())btnBlock{
    objc_setAssociatedObject(self, @selector(btnBlock), btnBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end
