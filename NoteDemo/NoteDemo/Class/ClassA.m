//
//  ClassA.m
//  NoteDemo
//
//  Created by byw on 2019/1/22.
//  Copyright © 2019 byw. All rights reserved.
//

#import "ClassA.h"

@implementation ClassA

- (Class)getMyClass{
    NSLog(@"AAAAA");
    return [self class];
}


//load一般是用来交换方法Method Swizzle，由于它是线程安全的，而且一定会调用且只会调用一次，通常在使用UrlRouter的时候注册类的时候也在load方法中注册
+(void)load{
    //load方法是在类被装在进来的时候就会调用，initialize在第一次给某个类发送消息时调用（比如实例化一个对象），并且只会调用一次，是懒加载模式
    NSLog(@"load ClassA");
}

//initialize方法主要用来对一些不方便在编译期初始化的对象进行赋值，或者说对一些静态常量进行初始化操作
+ (void)initialize{
    //真正使用到ClassA时 调用initialize方法
    NSLog(@"initialize ClassA");
}

/**
 https://www.jianshu.com/p/eb8db32c3853
 load 与 initialize 的区别
 
 1. 调用顺序
 以main为分界，load方法在main函数之前执行，initialize在main函数之后执行
 
 2.相同点和不同点
 2.1 相同点
 load和initialize会被自动调用，不能手动调用它们。
 子类实现了load和initialize的话，会隐式调用父类的load和initialize方法
 load和initialize方法内部使用了锁，因此它们是线程安全的。
 
 2.2 不同点
 子类中没有实现load方法的话，不会调用父类的load方法；而子类如果没有实现initialize方法的话，也会自动调用父类的initialize方法。
 load方法是在类被装在进来的时候就会调用，initialize在第一次给某个类发送消息时调用（比如实例化一个对象），并且只会调用一次，是懒加载模式，如果这个类一直没有使用，就不回调用到initialize方法。
 
 *****
 initialize并不是调用一次
 当ClassB中没有实现initialize方法时，会调用父类的  所以ClassA的initialize 有多次调用
 
 +initialize会被调用0次，一次，多次
 调用0次：表明这个类没有被使用到
 调用1次：表明只有这个类被使用到，它的子类要不然是没有被使用到，要不然就是有这个子类自己的+initialize(子类中+initialize中没有[super initialize]代码)方法
 调用多次：表明这个类或者它的多个子类被使用了，并且这多个子类没有自己的+initialize方法，子类会根据OC消息发送流程而调用了它父类的+initialize方法。
 或者可以这么理解，任何类在使用之前都会调用它的+initialize，如果这个类没有+initialize，那么就找它的父类的+initialize一直到NSObject类。并且不会自动调用 [super initialize]。
 

 3. load
 在执行load方法之前，会调用load_images方法，用来扫描镜像中的+load符号，将需要调用 load 方法的类添加到一个列表中loadable_classes，在这个列表中，会先把父类加入到待加载列表，这样保证父类在父类在子类钱调用load方法，而分类中的load方法会在类的load的方法后面加入另外一个待加载列表loadable_categories，这样保证了两个规则：
 父类先于子类调用
 类先于分类调用
 
 在扫描完load方法加入到待加载方法后，会调用call_load_methods，先从loadable_classes调用类的load方法，call_class_loads；调用完loadable_classes后会调用loadable_categories中分类的load方法，call_category_loads。
 调用顺序如下：
 父类load先于类添加到loadable_classes列表，通过call_class_loads，调用列表中的load方法，这样父类的load先于类的load执行
 当loadable_classes为空的时候，查看loadable_classes是否为空，如果不为空则调用call_category_loads加载分类中的load方法，这样分类的load在类之后执行
 
 4. initialize
 initialize 只会在对应类的方法第一次被调用时，才会调用，initialize 方法是在 alloc 方法之前调用的，alloc 的调用导致了前者的执行。
 initialize的调用栈中，直接调用其方法的其实是_class_initialize 这个C语言函数，在这个方法中，主要是向为初始化的类发送+initialize消息，不过会强制父类先发送。
 与 load 不同，initialize 方法调用时，所有的类都已经加载到了内存中。
 5. 使用场景
 5.1 load
 load一般是用来交换方法Method Swizzle，由于它是线程安全的，而且一定会调用且只会调用一次，通常在使用UrlRouter的时候注册类的时候也在load方法中注册
 5.2 initialize
 initialize方法主要用来对一些不方便在编译期初始化的对象进行赋值，或者说对一些静态常量进行初始化操作

 */

@end
