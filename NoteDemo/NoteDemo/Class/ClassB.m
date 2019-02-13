//
//  ClassB.m
//  NoteDemo
//
//  Created by byw on 2019/1/22.
//  Copyright © 2019 byw. All rights reserved.
//

#import "ClassB.h"


@implementation ClassB

- (void)testClass1{
    NSLog(@"selfClass:%@ , superClass:%@",[self class],[super class]);
}

- (void)testClass2{
    
    ClassA *a = [[ClassA alloc] init];
    NSLog(@"selfClass:%@ , superClass:%@-----%@",[self class],[a class],[super getMyClass]);
}

- (Class)getMyClass{
    NSLog(@"BBBBBB");
    return [self class];
}

+(void)load{
    NSLog(@"load ClassB");
}
//+ (void)initialize{
//    NSLog(@"initialize ClassB");
//}

@end


/*
 
 个人理解：[self class] [super class] 在没有重写的情况下 都会调用[NSObject class] 而它的实现是返回的消息接受者的类型
 //NSObject中 class方法 返回self的类型
 - (Class)class {
    return object_getClass(self);
 }
 当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；而当使用 super 时，则从父类的方法列表中开始找。
 简言之: [self op] [super op] 消息接受者都是self  而op方法的实现是返回消息接受者的类型 所以永远是self的类型
 
 [self op] 转成运行时就是: objc_msgSend(self, @selector(op));
 [super op]就是: objc_msgSendSuper(struct objc_super *super, @selector(op));
 
 struct objc_super {
    __unsafe_unretained id receiver;            //self(消息接受者)
    __unsafe_unretained Class super_class;      //父类
 };
 
 而当调用 [super class]时，会转换成objc_msgSendSuper函数。
 第一步先构造 objc_super 结构体，结构体第一个成员就是 self 。第二个成员是 (id)class_getSuperclass(objc_getClass(“Son”)) , 实际该函数输出结果为 Father。
 第二步是去 Father这个类里去找- (Class)class，没有，然后去NSObject类去找，找到了。最后内部是使用 objc_msgSend(objc_super->receiver, @selector(class))去调用，此时已经和[self class]调用相同了，故上述输出结果仍然返回ClassA。
 
 */
