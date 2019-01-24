//
//  TestMsgSend.m
//  NoteDemo
//
//  Created by byw on 2019/1/24.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestMsgSend.h"

@interface TestOtherObj : NSObject

@end

@implementation TestOtherObj

- (void)test1{
    NSLog(@"TestOtherObj run test1");
}

@end


@interface TestMsgSend ()
@property (nonatomic, strong) TestOtherObj *otherObj;
@end

@implementation TestMsgSend

- (instancetype)init{
    
    if (self = [super init]) {
        self.otherObj = [TestOtherObj new];
    }
    return self;
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    //判断是否为外部调用的方法
    if ([NSStringFromSelector(sel) isEqualToString:@"test2"]) {
        //[LMRuntimeTool addMethodWithClass:[self class] withMethodSel:sel withImpMethodSel:@selector(addDynamicMethod)];
        return YES;
    }
    return [super resolveClassMethod:sel];
}


//可动态添加方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    
    //判断是否为外部调用的方法
    if ([NSStringFromSelector(sel) isEqualToString:@"test1"]) {
        //对类进行对象方法 需要把方法添加进入类内
        //[LMRuntimeTool addMethodWithClass:[self class] withMethodSel:sel withImpMethodSel:@selector(addDynamicMethod)];
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

//返回其他可能响应的对象
-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"test1"]) {
        //return [TestOtherObj new];
        return self.otherObj;
    }
    return [super forwardingTargetForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
//    //创建备用对象
//    TestOtherObj *otherObj = [TestOtherObj new];
//    SEL sel = anInvocation.selector;
//    //判断备用对象是否可以响应传递进来等待响应的SEL
//    if ([otherObj respondsToSelector:sel]) {
//        [anInvocation invokeWithTarget:otherObj];
//    }else{
//        // 如果备用对象不能响应 则抛出异常
//        [self doesNotRecognizeSelector:sel];
//    }
    
    SEL sel = @selector(testWithString:);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    anInvocation = [NSInvocation invocationWithMethodSignature:signature];
    [anInvocation setTarget:self];
    [anInvocation setSelector:sel];
    NSString *text = @"北京";
    // 消息的第一个参数是self，第二个参数是sel，所以"北京"是第三个参数
    [anInvocation setArgument:&text atIndex:2];
    if ([self respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:self];
        return;
    } else {
        TestOtherObj *otherObj = [TestOtherObj new];
        if ([otherObj respondsToSelector:sel]) {
            [anInvocation invokeWithTarget:otherObj];
            return;
        }
    }
    // 从继承树中查找
    [super forwardInvocation:anInvocation];
}
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    //如果返回为nil则进行手动创建签名
    NSMethodSignature *sign = [super methodSignatureForSelector:aSelector];
    if (sign == nil) {
        sign = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return sign;
}
- (void)testWithString:(NSString *)text{
    NSLog(@"%@",text);
}



//最后找不到 抛出错误
- (void)doesNotRecognizeSelector:(SEL)aSelector{
    [super doesNotRecognizeSelector:aSelector];
    
}

@end



