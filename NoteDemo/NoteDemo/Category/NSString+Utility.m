//
//  NSString+Utility.m
//  NoteDemo
//
//  Created by byw on 2018/12/24.
//  Copyright © 2018 byw. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (NSUInteger)characterLength{
    
    //1.
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
    
    //2.
    //    int strlength = 0;
    //    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    //    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
    //        if (*p) {
    //            p++;
    //            strlength++;
    //        }
    //        else {
    //            p++;
    //        }
    //    }
    //    return strlength;
}

/** 限制字符数 */
- (NSString *)subcharacterWithMaxLength:(NSUInteger)maxLength{
    
    if (maxLength == 0) return @"";
    if (self.characterLength < maxLength) return self;
    
    NSRange range;
    NSMutableString *tmp = [[NSMutableString alloc] initWithString:self];
    do {
        range = [tmp rangeOfComposedCharacterSequenceAtIndex:tmp.length-1];
        [tmp deleteCharactersInRange:range];
        NSLog(@"%@",tmp);
        
    } while (tmp.characterLength > maxLength);
    
    return tmp;
}

- (NSString *)substringWithMaxLength:(NSUInteger)maxLength{
    
    if (maxLength == 0) return @"";
    if (self.length < maxLength)  return self;
    
    NSRange range = [self rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
    NSString *newStr = [self substringWithRange:range];
    if (newStr.length > maxLength) {
        range = [newStr rangeOfComposedCharacterSequenceAtIndex:newStr.length-1];
        newStr = [newStr substringToIndex:range.location];
    }
    return newStr;
}


- (void)logAllSubString{
    
    //遍历字符串中每个子串
    NSRange range;
    for(int i=0; i<self.length; i+=range.length){
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [self substringWithRange:range];
        NSLog(@"%@",s);
    }
}


@end
