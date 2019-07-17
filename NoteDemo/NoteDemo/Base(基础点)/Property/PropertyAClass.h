//
//  PropertyAClass.h
//  NoteDemo
//
//  Created by baoyewei on 2019/7/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertyAClass : NSObject



/** weak 与 assgin区别 */
@property (nonatomic, weak) id obj_weak;
@property (nonatomic, assign) id obj_assign;
- (void)obj_strongAssgiTest;



/** strong 与 copy */
@property (nonatomic, strong) NSArray *arrayStrong;
@property (nonatomic, copy) NSArray *arrayCopy;
@property (nonatomic, strong) NSMutableArray *muarrayStrong;
@property (nonatomic, copy) NSMutableArray *muarrayCopy;

- (void)array_test;
- (void)muarray_test;


/**https://www.jianshu.com/p/e1c818a6a997  Block三类型：global stack malloc
 
 没有引用外部变量的block是放在global区
 MRC下 引用了栈里的临时变量 被创建在stack区 stack区的块只要赋值给strong类型的变量, 就会自动copy到堆里 block的retain行为默认是用copy的行为实现的
 ARC下 引用外部变量一律是malloc类型 在堆上
 */
@property (nonatomic, copy) void(^block1)(void);
@property (nonatomic, strong) void(^block2)(void);


@end

NS_ASSUME_NONNULL_END
