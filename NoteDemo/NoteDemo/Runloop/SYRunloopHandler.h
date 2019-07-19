//
//  SYRunloopHandler.h
//  NoteDemo
//
//  Created by baoyewei on 2019/7/19.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface SYRunloopHandler : NSObject

+ (instancetype)shareHandler;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


- (void)addTask:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
