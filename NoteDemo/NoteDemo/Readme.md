
1. 寻找响应View  （hitTest:withEvent:  内部调用pointInside:withEvent:）
    事件链：UIApplication对象——>UIWindow对象——>rootVC.view对象——>subviews
    1.判断自身能否接受触摸事件        当userInteractionEnabled=NO hidden=YES alpha=0 这三种情况不能接受事件
    2.判断触摸点是否在自己的身上
    3.遍历自己所有的子试图，去找到最合适的VIew，从后往前遍历，意思就是说，从自己的子试图中倒序遍历，然后去重复1.2
    
    响应链：通过上面事件链找到view后，如何不能响应则通过nextResponder向下传递直到window层，若还没有则事件无效
    
    引申题: 寻找两个子view最近的父view？
    方案：遍历两个子view的superView得到两个数组，如果两个子view有相同的父view，则数组内的最后几个对象相同(类似于寻找两个相交链表的第一个相交点)
                让长数组先走count2-count1步, 两个数组再一起遍历，第一个相等对象即最近的父view

2.  内存泄漏常见例子及解决方案
Block: 避免循环引用使用weak指针。  NSTimer: 使用YYWeakProxy  让self强引用timer，timer强引用proxy；proxy弱引用self；避免相互强引用

3. 单例的优化方案---详见TestSingletonObj
    推荐第一种(三方框架使用):  使用NS_UNAVAILABLE来禁止调用init和new方法
    第二种: 重写allocWithZone:  如有需要copyWithZone: mutableCopyWithZone:等  MRC下retain  release方法

4.消息转发机制

    1.Method resolution 动态方法解析处理阶段  +(BOOL)resolveInstanceMethod:(SEL)sel
    2.Fast forwarding 备援接受者       -(id)forwardingTargetForSelector:(SEL)aSelector
    3.Normal forwarding 完整的消息转发     -(void)forwardInvocation:(NSInvocation *)anInvocation
    
5. frame和bounds的区别
    frame指的是这个view在它superview的坐标系的坐标和大小
    bounds是指这个view在它自己坐标系的坐标和大小  设置bounds可以修改自己坐标系的原点位置，进而影响到其“子view”的显示位置。

6. self/super [self class] [super class]  ---详见TestClassViewController

7. Block有几种  http://www.cocoachina.com/cms/wap.php?action=article&id=23147
    NSGlobalBlock 静态区block,这是一种特殊的bloclk,因为不引用外部变量而存在。另外,作为静态区的对象,它的释放是有操作系统控制的,这一点我们最后再聊。 
    NSStackBlock 栈区block,位于内存的栈区,一般作为函数的参数出现。 
    NSMallocBlock 堆区block,位于内存的堆区,一般作为对象的property出现。
    
    2.1 Block声明及定义语法，及其变形
    //方法中
    return_type (^blockName)(var_type) = ^return_type (var_type varName) { // ... };
    //属性
    @property(nonatomic, copy) return_type (^blockName) (var_type);
    //参数
    -(void)yourMethod:(return_type (^)(var_type))blockName;
    //block作返回值
    - (return_type(^)(var_type))methodName
    //利用typedef简化Block的声明
    typedef return_type (^BlockTypeName)(var_type);
    
8.load与initialize的区别  见ClassA.m










 
iOS中isKindOfClass和isMemberOfClass的区别  

https://www.jianshu.com/p/04f84472c1b8


NSURLConnection 与 NSURLSession的区别
NSURLProtocol详解和应用
NSProxy
GCD NSOpeartion NSThread
CADisplayLink  NSTimer  GCD 三种定时器


