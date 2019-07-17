//
//  CopyModel.h
//  NoteDemo
//
//  Created by baoyewei on 2019/7/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CopyModelItem;



/**
 自定义类的copy实现  实现NSCopying协议中的copyWithZone: 
 */
@interface CopyModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;


@property (nonatomic, strong) CopyModelItem *item;


@property (nonatomic, strong) NSMutableArray<CopyModelItem *> *arr;


- (void)string_copy;
- (void)array_copy;
@end


@interface CopyModelItem : NSObject<NSCopying>

@property (nonatomic, copy) NSString *str;

@end


NS_ASSUME_NONNULL_END
