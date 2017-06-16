//
//  BYModel.h
//  TestUIViewController
//
//  Created by baoyewei on 17/3/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYModel : NSObject

@property (copy, nonatomic) NSString *key;
@property (copy, nonatomic) NSString *value;

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value;
+(instancetype)modelWithKey:(NSString *)key value:(NSString *)value;
@end
