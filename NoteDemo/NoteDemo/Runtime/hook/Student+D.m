//
//  Student+D.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/19.
//  Copyright © 2019 byw. All rights reserved.
//

#import "Student+D.h"
#import "NSObject+DLIntrospection.h"
#import <objc/runtime.h>

//https://blog.csdn.net/qq_34047841/article/details/78467477  Hook安全隐患

@implementation Student (D)


//Pepple中有eat / see
//Student中有study / see


+ (void)load{
        
//    [Student swizzleSEL:@selector(see) withSEL:@selector(hook_see)];
    
    Class class = [self class];
    
    SEL originalSEL = @selector(see);
    SEL swizzledSEL = @selector(hook_see);
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
//    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    
    //可通过尝试 注视/打开 Student中的see方法 来体会交换方法时AddMethod的必要性
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

- (void)hook_see{

    NSLog(@"Student hook see -- %@",self.class);
    [self hook_see];
}

@end

/**
 //http://yulingtianxia.com/blog/2017/04/17/Objective-C-Method-Swizzling/
 先尝试Add的原因解析 : 再判断add成功与否 时交换还是替换
 
 在Student+D 分类中写了hook_see:
 当尝试hook see方法时，如果Student未重写此方法，如果直接交换 就会hook到People的原方法
 此时向Student *s 发送see消息 由于交换，
 
 

 
 后面待议:
 会执行父类类中执行hook_see 当执行到最后一句的[self hook_see]时
 由于此方法存在于子类Student中 所以会找不到方法导致崩溃
 
 所以交换方法时，需保证两个方法调用的类相同
 */
