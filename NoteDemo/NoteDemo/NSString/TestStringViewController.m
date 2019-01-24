//
//  TestStringViewController.m
//  NoteDemo
//
//  Created by byw on 2019/1/23.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestStringViewController.h"
#import "NSString+Utility.h"

@interface TestStringViewController ()

@end

@implementation TestStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self testComponentsSeparate];
    
    [self testComplementSubString];
}






/** 截取完整字符串 */
- (void)testComplementSubString{
    
    //由于emoji 中英文 所占length与字节数都不同  当使用substringToIndex等类似方法时，有可能导致末尾字符不完整
    //常见于输入框限制字数的需求  [@"abcdfs😯fe😯eg😯e中文😯" substringToIndex:12];
    //NSString+Utility
    
   
    
}

/** 系统分割字符串的原则 */
- (void)testComponentsSeparate{
    
    NSString *str = @"abbbba";
    
    NSArray *arr0 = [str componentsSeparatedByString:@"a"];         //
    NSArray *arr1 = [str componentsSeparatedByString:@"ab"];
    NSArray *arr2 = [str componentsSeparatedByString:@"ba"];
    NSArray *arr3 = [str componentsSeparatedByString:@"b"];         //
    NSArray *arr4 = [str componentsSeparatedByString:@"bb"];        //
    NSArray *arr5 = [str componentsSeparatedByString:@"bbb"];
    NSArray *arr6 = [str componentsSeparatedByString:@"bbbb"];
    NSArray *arr7 = [str componentsSeparatedByString:@"abbbba"];    //
    
    NSLog(@"%@",str);
    
    /*
     总结后发现：当被截字符串在两端时，插入""  若不是两端则直接分割
     
     使用"b"时 第一次分割后为 "a" "bbba"; 第二次分割,b在左端插入"",变成"a" "" "bba" 循环结束 结果为 "a" "" "" "" "a"
     使用"bb"时 第一次分割后为 "a" "bba"; 第二次分割,bb在左端插入"" , 变成"a" "" "a"
     使用abbbba时,第一次截取，在左端插入“” ,变成 "" ""
     */
    
}

@end
