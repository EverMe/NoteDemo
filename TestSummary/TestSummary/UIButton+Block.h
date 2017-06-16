//
//  UIButton+Block.h
//  TestSummary
//
//  Created by baoyewei on 2017/6/7.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Block)

- (void)addBlockForTouchUpInside:(void (^)())block;

@end
