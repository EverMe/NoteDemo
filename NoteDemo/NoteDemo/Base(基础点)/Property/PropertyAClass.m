//
//  PropertyAClass.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "PropertyAClass.h"

@implementation PropertyAClass


/** 弱类型使用weak */
- (void)obj_strongAssgiTest{
    
    @autoreleasepool {
        
        PropertyAClass *p = [[PropertyAClass alloc] init];
        self.obj_weak = p;
        self.obj_assign = p;
        NSLog(@"before self:%p, p.weak:%p , p.assign:%p", self , self.obj_weak , self.obj_assign);
        p = nil;
    }
    
    NSLog(@"p.weak:%p", self.obj_weak);
    NSLog(@"p.assign:%p",self.obj_assign); //报也指针崩溃
    
    
    
   /**
    相同点：都不会造成引用计数+1
    不同点：weak只能用来修饰对象。assgin可用来修饰对象和基本数据类型
            当weak修饰的对象被释放时，会被置为nil
    
    weak实现原理：
    runtime维护了一张哈希表，weak对象的地址为key value是所有指向此对象地址的weak指针的地址数组
    当对象被释放时，以对象地址为key 找到对应的地址数组，遍历拿到weak指针的地址 并将其内容置为nil
    完成后，删除此条key-value记录
    
    weak 的实现原理可以概括一下三步：
    1、初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
    2、添加引用时：objc_initWeak函数会调用 objc_storeWeak() 函数， objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表。
    3、释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，
    然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
    */
}

//不可变数组推荐使用Copy。 Strong和Copy
- (void)array_test{
    
    NSArray *tmp1 = [[NSArray alloc] initWithObjects:@"1",@"2", nil];
    self.arrayStrong = tmp1;
    NSLog(@"tmp1:%p  arrayStrong:%p class:%@",tmp1,self.arrayStrong,[self.arrayStrong class]);
    
    NSArray *tmp2 = [[NSArray alloc] initWithObjects:@"2",@"3", nil];
    self.arrayCopy = tmp2;
    NSLog(@"tmp2:%p  arrayCopy:%p class:%@",tmp2,self.arrayCopy,[self.arrayCopy class]);
    
    /**
     NSArray 使用strong和copy效果相同 不会创建新对象 浅拷贝(指针拷贝) 但推荐使用copy
     
     因为@property (nonatomic, strong) NSArray *arrayStrong;
     当创建一个NSMutableArray *tmp 并把他赋给arrayStrong时，
     如果使用strong 则外部tmp修改 arrayStrong只是指针拷贝 所以打印结果跟着变
     
     但使用了copy 当tmp赋给arrayCopy时，由于调用了【tmp copy】赋给了arrayCopy
     tmp是NSMutableArray 所以新建了数组对象 tmp如何添加 都不会影响新建的arrayCopy数组的结果 依旧是初始值
     
     */
    
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithObjects:@"mutable1",@"mutable2", nil];
    self.arrayStrong = tmp;
    self.arrayCopy = tmp;
    NSLog(@"tmp:%p  arrayStrong:%p class:%@",tmp,self.arrayStrong,[self.arrayStrong class]);
    NSLog(@"tmp:%p  arrayCopy:%p class:%@",tmp,self.arrayCopy,[self.arrayCopy class]);
    
    [tmp addObject: @"add"];
    NSLog(@"strong:%@  copy:%@",self.arrayStrong , self.arrayCopy); //无论原对象是NS/NSMutable copy后都是不可变的
    
}

//可变数组使用Strong。
- (void)muarray_test{
    
    
    NSMutableArray *tmp1 = [[NSMutableArray alloc] initWithObjects:@"1", nil];
    self.muarrayStrong = tmp1;
    NSLog(@"tmp1:%p  muarrayStrong:%p class:%@",tmp1,self.muarrayStrong,[self.muarrayStrong class]);
    
    NSMutableArray *tmp2 = [[NSMutableArray alloc] initWithObjects:@"2", nil];
    self.muarrayCopy = tmp2;
    NSLog(@"tmp2:%p  muarrayCopy:%p class:%@",tmp2,self.muarrayCopy,[self.muarrayCopy class]);
    
    /**
     NSMutable copy后都是不可变的 所以必须使用stong
     
     Copy
     NS*                NS*         不产生新对象      浅拷贝(指针拷贝)
     NSMutable*         NS*         产生新对象        深拷贝(内容拷贝)
     
     (补充)NSNumber          NSNumber     产生新对象       深拷贝(内容拷贝)
     */
    
}




- (void)dealloc{

    NSLog(@"%p : dealloc" , self);
}

@end
