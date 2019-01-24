//
//  TestSingletonObj.h
//  NoteDemo
//
//  Created by byw on 2019/1/24.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 单例类的优化 */
@interface TestSingletonObj : NSObject

+ (instancetype)sharedSingleton1;
//第一种推荐: 三方框架中许多类似写法 利用NS_UNAVAILABLE 禁止调用init new方法
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

//第二种: 重写allocWithZone: 等方法 直接return [TestSingletonObj sharedSingleton];  如有必要 copyWithZone: mutableCopyWithZone:等
+ (instancetype)sharedSingleton2;
@end

NS_ASSUME_NONNULL_END
