//
//  UIView+BYFrame.h
//  TestSummary
//
//  Created by baoyewei on 17/3/28.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BYFrame)

/** X */
@property (nonatomic, assign) CGFloat x;

/** Y */
@property (nonatomic, assign) CGFloat y;

/** Width */
@property (nonatomic, assign) CGFloat width;

/** Height */
@property (nonatomic, assign) CGFloat height;

/** size */
@property (nonatomic, assign) CGSize size;

/** centerX */
@property (nonatomic, assign) CGFloat centerX;

/** centerY */
@property (nonatomic, assign) CGFloat centerY;

@end
