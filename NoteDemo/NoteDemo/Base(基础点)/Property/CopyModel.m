//
//  CopyModel.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "CopyModel.h"

//https://blog.csdn.net/u011363981/article/details/72426342

@implementation CopyModel


- (void)test_string{
    
    //string的特殊优化
    
    /**
     
     第一种: withString @"" _NSCFConstantString类型 代表一个字符串常量 retain和copy无效 不管数据长短都在常量区
     第二种: withFormat  stringWithFormat    initWithFormat:
            字符串长度>9的时候，字符创的类型是__NSCFString，<=9时是NSTaggedPointerString类型
     
     __NSCFString 表示对象类型的字符串，可以把他理解为正常的符合内存管理规则的字符串
     NSTaggedPointerString类型的字符串是对__NSCFString类型的一种优化在运行时创建字符串时，会对字符串内容及长度作判断
     若内容由ASCII字符构成且长度较小（具体要多小暂时不太清楚）创建的字符串类型就是 NSTaggedPointerString （标签指针字符串），字符串直接存储在指针的内容中.NSTaggedPointerString类也不符合内存管理的规则。

     */
    
    
    NSString *str1 = @"abc";
    NSString *str2 = @"abc";
    NSString *str3 = [NSString stringWithFormat:@"abc"];
    NSString *str4 = [NSString stringWithFormat:@"%@",str1];
    NSString *str5 = [[NSString alloc] initWithFormat:@"%@",@"abc"];
    NSString *str6 = [[NSString alloc] initWithFormat:@"%@",str1];
    NSLog(@"str1:%p  str2:%p  str3:%p  str4:%p  str5:%p str6:%p" ,str1 , str2 , str3 , str4 ,str5 ,str6);
    
    NSString *str7 = [NSString stringWithString:str4];
    NSString *str8 = [NSString stringWithFormat:@"%@",str4];
    NSString *str9 = [[NSString alloc] initWithFormat:@"%@",str4];
    NSString *str10 = [NSString stringWithUTF8String:"abc"];
    NSLog(@"str7:%p  str8:%p  str9:%p str10:%p" ,str7 , str8 , str9 , str10);


}


- (void)string_copy{
    
    
    NSString *str1 = @"abc";
    NSString *str2 = @"abc";
    NSString *str3 = [NSString stringWithFormat:@"abcsflsdjfljsl"];
    NSString *s_copy = [str1 copy];
    NSString *s_mucopy = [str1 mutableCopy];
    NSLog(@"s_copy:%p class:%@ s_mucopy:%p class:%@ ",s_copy , s_copy.class  , s_mucopy , s_mucopy.class);
    
    NSString *ss_copy = [str3 copy];
    NSString *ss_mucopy = [str3 mutableCopy];
    NSLog(@"ss_copy:%p class:%@ ss_mucopy:%p class:%@ ",ss_copy , ss_copy.class  , ss_mucopy , ss_mucopy.class);
    
    if ([ss_copy respondsToSelector:@selector(appendString:)]) {
        NSLog(@"mumumumu");
    }
    
    
    NSMutableString *mus = [NSMutableString stringWithFormat:@"mus"];
    NSMutableString *mus_copy = [mus copy];
    NSMutableString *mus_mucopy = [mus mutableCopy];
    NSLog(@"mus:%p  mus_copy:%p class:%@ mus_mucopy:%p class:%@ ", mus ,mus_copy , mus_copy.class  , mus_mucopy , mus_mucopy.class);
    
    
}


- (void)array_copy{
    
    
    NSArray *arr1 = @[@"12",@"34" ];
    NSArray *arr2 = [arr1 copy];
    NSArray *arr3 = [arr1 mutableCopy];
    
    NSLog(@"arr1:%p copy:%p class:%@  ",arr1,arr2,[arr2 class]);
    NSLog(@"arr1:%p mucopy:%p class:%@  ",arr1,arr3,[arr3 class]);

    NSMutableArray *muarr1 = [[NSMutableArray alloc] initWithArray:arr1 copyItems:YES];
    NSMutableArray *muarr2 = [muarr1 copy];
    NSMutableArray *muarr3 = [muarr1 mutableCopy];
    
    NSLog(@"muarr1:%p copy:%p class:%@  ",muarr1,muarr2,[muarr2 class]);
    NSLog(@"muarr1:%p mucopy:%p class:%@  ",muarr1,muarr3,[muarr3 class]);
    
    
}



- (id)copyWithZone:(NSZone *)zone{
    

    CopyModel *m = [[CopyModel allocWithZone:zone] init];
    m.name = self.name.copy;
    m.age = self.age;
    
    m.item = self.item.copy;
    m.arr = self.arr.mutableCopy;
    //如果需要完全拷贝
    //m.arr = [[NSMutableArray alloc] initWithArray:self.arr copyItems:YES];
    
    return m;
}


@end


@implementation CopyModelItem

- (id)copyWithZone:(NSZone *)zone{
    
    CopyModelItem *item = [[CopyModelItem allocWithZone:zone] init];
    item.str = [self.str copy];
    return item;
}

@end
