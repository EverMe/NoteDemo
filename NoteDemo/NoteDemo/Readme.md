
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

3. 单例的优化方案---详见Something---TestSingletonObj
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
    http://www.cocoachina.com/ios/20180628/23965.html
    
    block本质上是一个OC对象，它内部有个isa指针（block最终都是继承自NSBlock类型，而NSBlock继承于NSObjcet。那么block其中的isa指针其实是来自NSObject中的。这也更加印证了block的本质其实就是OC对象），block是封装了函数调用以及函数调用环境的OC对象。
    Block是可以获取其他函数局部变量的匿名函数，其不但方便开发，并且可以大幅提高应用的执行效率(多核心CPU可直接处理Block指令)
    1.三种类型
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


9. 通知/代理/block的区别与使用
    在消息传递中，block其实只是一个对象，代理/通知是一种设计模式（代理委托模式/通知观察者模式）
    通知：一对多 ，block和代理一般是一对一
    block的优势：代码可读性更好，写起来方便，不需要像代理声明协议，写协议方法等
    block的劣势：运行成本相较于代理高，因为需要封装数据和上下文到到堆内存和block内的对象引用计数+1使用完或者block置nil后才消除
                            而代理只保存了一个对象指针 ，其次block容易造成循环引用，出现内存泄露情况，代理相对安全许多。
    如何使用：
    优先使用block。
    如果回调的状态很多，多于三个使用代理。
    如果回调的很频繁，次数很多，像UITableview，每次初始化、滑动、点击都会回调，使用代理。
    
10.离屏渲染的理解与优化 
    On-Screen Rendering：当前屏幕渲染，指的是在当前用于显示的屏幕缓冲区中进行渲染操作。
    Off-Screen Rendering：离屏渲染，指的是 GPU 或 CPU 在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。过程中需要切换 contexts (上下文环境),先从当前屏幕切换到离屏的contexts，渲染结束后，又要将 contexts 切换回来，而切换过程十分耗费性能。
        GPU 产生的离屏渲染主要是当 CALayer 使用圆角，阴影，遮罩等属性的的时候，图层属性的混合体被指定为在未预合成之前不能直接在屏幕中渲染，则过程中需要进行离屏渲染。
        由于垂直同步的机制，如果在一个 HSync（刷新频率FPS 1/60s） 时间内，CPU 或者 GPU 没有完成内容提交，则那一帧就会被丢弃，等待下一次机会再显示，而这时显示屏会保留之前的内容不变。这就是界面卡顿的原因。既然离屏渲染这么耗性能,为什么有这套机制呢?
        有些效果被认为不能直接呈现于屏幕，而需要在别的地方做额外的处理预合成。图层属性的混合体没有预合成之前不能直接在屏幕中绘制，所以就需要屏幕外渲染。屏幕外渲染并不意味着软件绘制，但是它意味着图层必须在被显示之前在一个屏幕外上下文中被渲染（不论CPU还是GPU）。

        链接：https://www.jianshu.com/p/cff0d1b3c915

UIView 和 CALayer 的关系 ：简单来说，UIView 是对 CALayer 的一个封装。
    CALayer 负责显示内容contents，UIView 为其提供内容，以及负责处理触摸等事件，参与响应链。
    
11.NSTimer与CADisplayLink的区别
1.原理不同 
CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。 CADisplayLink以特定模式注册到runloop后， 每当屏幕显示内容刷新结束的时候，runloop就会向 CADisplayLink指定的target发送一次指定的selector消息，  CADisplayLink类对应的selector就会被调用一次。 
NSTimer以指定的模式注册到runloop后，每当设定的周期时间到达后，runloop会向指定的target发送一次指定的selector消息。 

2.周期设置方式不同

iOS设备的屏幕刷新频率(FPS)是60Hz，                 
因此CADisplayLink的selector 默认调用周期是每秒60次，这个周期可以通过frameInterval属性设置， CADisplayLink的selector每秒调用次数=60/ frameInterval。比如当 frameInterval设为2，每秒调用就变成30次。因此， CADisplayLink 周期的设置方式略显不便。 

NSTimer的selector调用周期可以在初始化时直接设定，相对就灵活的多。 

3、精确度不同
iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。 
NSTimer的精确度就显得低了点，比如NSTimer的触发时间到的时候，runloop如果在阻塞状态，触发时间就会推迟到下一个runloop周期。并且 NSTimer新增了tolerance属性，让用户可以设置可以容忍的触发的时间的延迟范围。 

4、使用场景
CADisplayLink使用场合相对专一，适合做UI的不停重绘，比如自定义动画引擎或者视频播放的渲染。 
NSTimer的使用范围要广泛的多，各种需要单次或者循环定时处理的任务都可以使用。 

  
12.iOS图片加载过程解析及优化  http://blog.cnbang.net/tech/2578/  
        https://www.jianshu.com/p/72dd074728d8

13.使用GCD实现NSMutableArray的安全读取
    用dispatch_sync和dispatch_barrier_async结合保证NSMutableArray的线程安全，dispatch_sync是在当前线程上执行不会另开辟新的线程，当线程返回的时候就可以拿到读取的结果，我认为这个方案是最完美的选择，既保证的线程安全有发挥了多线程的优势还不用另写方法返回结果
    https://www.jianshu.com/p/35bffa1c16ac


iOS中isKindOfClass和isMemberOfClass的区别  
https://www.jianshu.com/p/04f84472c1b8


NSURLConnection 与 NSURLSession的区别
NSURLProtocol详解和应用
NSProxy
GCD NSOpeartion NSThread
CADisplayLink  NSTimer  GCD 三种定时器


100. iOS 静态库 动态库 framework的理解 (https://www.jianshu.com/p/a37328bcee8f)
a 文件肯定是静态库, .dylib/.tbd肯定是动态库, .framework 可能是静态库也可能是动态库
静态库在链接时, 会被完整的赋值到可执行文件中, 如果多个APP都使用了同一个静态库, 那么每个APP都会拷贝一份, 缺点是浪费内存, 类似于定义一个基本变量, 使用该基本变量是新复制了一份数据, 而不是原来定义的
动态库不会复制,只有一份, 程序运行时动态加载到内存中, 系统只会加载一次, 多个程序公用一份, 节约了内存. 类似于使用变量的内存地址一样. 使用的是同一个变量
但是项目中如果使用了自己定义的动态库, 苹果是不允许上架的, 在 iOS8 后 苹果开放了动态加载 .dylib 的接口, 用于挂载 .dylib 动态库
好处：1.封闭隐藏代码  2.MRC的项目打包成静态库, 可以在ARC下直接使用, 不用转换
使用.a 时 需要同时将.a 和 .h 文件拖入到工程中, 使用 .framework时 直接将这个文件夹拖入进去即可, 因为 .framework 文件夹中已经包含了 .h 文件
.a + .h + .bundle = .framework 所以使用framework 更方便


1. struct 与 class的区别 （C++对struct作了扩展 有成员函数 构造 析构 可继承 多态等）
    1)权限：struct在继承和成员访问时默认都是public 而class都是private
    2)作为参数传递时，struct作为一个数据结构作为参数传递时是值传递 而class是对象传递的是指针地址
    3)“class”这个关键字还用于定义模板参数，就像“typename”。但关键字“struct”不用于定义模板参数。
