//
//  BYModel.m
//  TestUIViewController
//
//  Created by baoyewei on 17/3/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "BYModel.h"

@implementation BYModel

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value{
    
    if (self = [super init]) {
        self.key = key;
        self.value = value;
    }
    return self;
}

+(instancetype)modelWithKey:(NSString *)key value:(NSString *)value{
    BYModel *model = [[BYModel alloc] initWithKey:key value:value];
    return model;
}

@end
