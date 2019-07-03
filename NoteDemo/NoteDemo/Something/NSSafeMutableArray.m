//
//  NSSafeMutableArray.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/3.
//  Copyright © 2019 byw. All rights reserved.
//

#import "NSSafeMutableArray.h"

/**
//1.NSMutableArray线程安全的思考和实现
https://blog.csdn.net/kongdeqin/article/details/53171189

//2.executeQueue为单例Queue？？？？？ 如果不是 在dealloc中释放
https://blog.csdn.net/weixin_34384557/article/details/87058029
https://www.jianshu.com/p/ed2030920ec4

*/
 
@interface NSSafeMutableArray ()
{
    CFMutableArrayRef _array;
}

@property (nonatomic, strong) dispatch_queue_t executeQueue;

@end


@implementation NSSafeMutableArray


- (dispatch_queue_t)executeQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.kong.NSKSafeMutableArray", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

- (id)init
{
    return [self initWithCapacity:10];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        _array = CFArrayCreateMutable(kCFAllocatorDefault, numItems,  &kCFTypeArrayCallBacks);
    }
    return self;
}


- (NSUInteger)count{
    
    __block NSUInteger _count;
    dispatch_sync(self.executeQueue, ^{
        _count = CFArrayGetCount(_array);
    });
    return _count;
}

- (id)objectAtIndex:(NSUInteger)index{
    
    __block id obj;
    dispatch_sync(self.executeQueue, ^{
        NSUInteger count = CFArrayGetCount(_array);
        obj = index<count ? CFArrayGetValueAtIndex(_array, index) : nil;
    });
    return obj;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    __block NSUInteger blockindex = index;
    dispatch_barrier_async(self.executeQueue, ^{
        
        if (!anObject)
            return;
        
        NSUInteger count = CFArrayGetCount(_array);
        if (blockindex > count) {
            blockindex = count;
        }
        
        CFArrayInsertValueAtIndex(_array, blockindex, (__bridge const void *)anObject);
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    
    dispatch_barrier_async(self.executeQueue, ^{
        
        NSUInteger count = CFArrayGetCount(_array);
        if (index < count) {
            CFArrayRemoveValueAtIndex(_array, index);
        }
    });
}


- (void)addObject:(id)anObject{
    
    dispatch_barrier_async(self.executeQueue, ^{
        
        if (!anObject)
            return;
        CFArrayAppendValue(_array, (__bridge const void *)anObject);
    });
}

- (void)removeLastObject{
    
    dispatch_barrier_async(self.executeQueue, ^{
        
        NSUInteger count = CFArrayGetCount(_array);
        if (count > 0) {
            CFArrayRemoveValueAtIndex(_array, count-1);
        }
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    
    dispatch_barrier_async(self.executeQueue, ^{
        
        if (!anObject)
            return;
        
        NSUInteger count = CFArrayGetCount(_array);
        if (index < count) {
            CFArraySetValueAtIndex(_array, index, (__bridge const void*)anObject);
        }
    });

}

#pragma mark Optional
- (void)removeAllObjects{
    
    dispatch_barrier_async(self.executeQueue, ^{
        CFArrayRemoveAllValues(_array);
    });
}

- (NSUInteger)indexOfObject:(id)anObject{
    
    if (!anObject)
        return NSNotFound;
    
    __block NSUInteger result;
    dispatch_sync(self.executeQueue, ^{
        NSUInteger count = CFArrayGetCount(_array);
        result = CFArrayGetFirstIndexOfValue(_array, CFRangeMake(0, count), (__bridge const void *)(anObject));
    });
    return result;
}


@end



/**
 
 NSMutableArray是线程不安全的，当有多个线程同时对数组进行操作的时候可能导致崩溃或数据错误，下面是我对线程安全的几个思路，希望由此能给你带来一些思路，如果有错误的地方还希望大家能够指出
 1.对数组的读写都加锁，虽然数组是线程安全了，但失去了多线程的优势
 
 2.然后又想可以只对写操作加锁然后定义一个全局变量来表示现在有没有写操作，如果有写操作就等写完了在读，那么问题来了如果一个线程先读取数据紧接着一个线程对数组写的操作，读的时候还没有加锁同样会导致崩溃或数据错误，这个方案pass掉
 
 3.第三种方案说之前先介绍一下dispatch_barrier_async，dispatch_barrier_async 追加到 queue 中后，会等待 queue 中的任务都结束后，再执行 dispatch_barrier_async 的任务，等 dispatch_barrier_async 的任务结束后，才恢复任务执行， 用dispatch_async和dispatch_barrier_async结合保证NSMutableArray的线程安全，用dispatch_async读和dispatch_barrier_async写（add,remove,replace），当有任务在读的时候写操作会等到所有的读操作都结束了才会写，同样当有写任务时，读任务会等写操作完了才会读，既保证了线程安全又发挥了多线程的优势，但还是有个不足，当我们重写读的方法时dispatch_async是另开辟线程去执行的而且是立马返回的，所以我们不能拿到执行结果，需要去另写一个方法来返回读的结果，但是我们又不想改变调用者的习惯于是又想到了一下方案
 
 4.用dispatch_sync和dispatch_barrier_async结合保证NSMutableArray的线程安全，dispatch_sync是在当前线程上执行不会另开辟新的线程，当线程返回的时候就可以拿到读取的结果，我认为这个方案是最完美的选择，既保证的线程安全有发挥了多线程的优势还不用另写方法返回结果，完美~

 
 数组线程安全的实现
 下面咱们来看一下NSMutableArray线程安全的实现
 
 1 继承 NSMutableArray创建NSKSafeMutableArray在这个地方遇到了一些坑通过查阅文档发现问题所在：
 在 Cocoa 中有一种奇葩的类存在 Class Clusters。面向对象的编程告诉我们：“类可以继承，子类具有父类的方法”。而 Cocoa 中的 Class Clusters 虽然平时表现的像普通类一样，但子类却没法继承父类的方法。 NSMutableArray就是这样的存在。为什么会这样呢？因为 Class Clusters 内部其实是由多个私有的类和方法组成。虽然它有这样的弊端，但是好处还是不言而喻的。例如，NSNumber 其实也是这种类，这样一个类可以把各种不同的原始类型封装到一个类下面，提供统一的接口。这正设计模式中的抽象工厂模式。
 
 查看Apple的文档，要继承这样的类需要必须实现其primitive methods方法，实现了这些方法，其它方法便都能通过这些方法组合而成。比如需要继承NSMutableArray就需要实现它的以下primitive methods：
 
 - (void)addObject:(id)anObject;
 - (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
 - (void)removeLastObject;
 - (void)removeObjectAtIndex:(NSUInteger)index;
 - (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

 和NSArray的primitive methods：
 
 - (NSUInteger)count;
 - (id)objectAtIndex:(NSUInteger)index;
 
 */
