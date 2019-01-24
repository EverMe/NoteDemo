//
//  NSString+Utility.h
//  NoteDemo
//
//  Created by byw on 2018/12/24.
//  Copyright © 2018 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Utility)

/** 获取字符数
 length:        英文+1  中文+1  emoji +2/+4(国旗)
 character :    英文+1  中文+2  emoji +4/+8
 */
- (NSUInteger)characterLength;
/** 限制字符数 */
- (NSString *)subcharacterWithMaxLength:(NSUInteger)length;
- (NSString *)substringWithMaxLength:(NSUInteger)legnth;
@end

NS_ASSUME_NONNULL_END
