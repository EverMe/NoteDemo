//
//  People+A.m
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "People+A.h"
#import "NSObject+DLIntrospection.h"
#import <objc/runtime.h>

//https://www.jianshu.com/p/44e20fd2efa8?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation


@implementation People (A)

+(void)load{
    
    
    NSLog(@"People A load");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //拦截方法
        [People swizzleSEL:@selector(eat) withSEL:@selector(a_eat)];
        
        //拦截代理方法
        [People swizzleSEL:@selector(setDelegate:) withSEL:@selector(a_setDelegate:)];
    });
}

- (void)a_eat{
    
    NSLog(@"People A eat");
    [self a_eat];
}


/**
 https://www.jianshu.com/p/44e20fd2efa8?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
 拦截设置delegate方法 用于判断delegate是否实现了想要拦截的方法
 */
- (void)a_setDelegate:(id)delegate{
    
    SEL old_sel = @selector(peopleRun);
    
    //可写成方法 传入原代理方法SEL 和 替换后的SEL 用于添加hook
    if ([delegate respondsToSelector:old_sel]) {
        
        SEL new_sel = @selector(a_peopleRun);
        
        Method dele_M = class_getInstanceMethod([delegate class], old_sel);
        Method new_M = class_getInstanceMethod(self.class, new_sel);
        
//        类对象不同 一旦直接交换 相当于代理类执行a_peopleRun 当中的self是delegate.class
//        而本class中拥有了原来的代理类的实现 其中的self也会变换People对象。所以无法使用交换
//        method_exchangeImplementations(dele_M, new_M);
        
        // 如果实现了  则在delegate类中 动态添加 hook_sel 用于保存旧的方法实现
        //并替换旧方法为hook_sel 当在hook_sel 中调用自身时，会调用到上面保存的旧方法实现
        BOOL isVictory = class_addMethod([delegate class], new_sel, class_getMethodImplementation([delegate class], old_sel), method_getTypeEncoding(dele_M));
        if (isVictory) {
            class_replaceMethod([delegate class], old_sel, class_getMethodImplementation([self class], new_sel), method_getTypeEncoding(new_M));
        }
    }
    [self a_setDelegate:delegate];
}

- (void)a_peopleRun{
    
    NSLog(@"a_peopleRun");
    
    [self a_peopleRun];

    
//    NSLog(@"%s -- %@",_cmd,self.class);
//    NSString *currentM = NSStringFromSelector(_cmd);
    
    
}


@end
