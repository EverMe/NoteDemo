//
//  TestBasePointController.m
//  NoteDemo
//
//  Created by baoyewei on 2019/7/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import "TestBasePointController.h"
#import "Property/PropertyAClass.h"
#import "Property/CopyModel.h"

@interface TestBasePointController ()

@property (nonatomic, copy) NSString *string;


@property (nonatomic, copy) void(^blockG)(void);
@property (nonatomic, strong) void(^blockS)(void);


@end

@implementation TestBasePointController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    int a = 0;
    self.blockG = ^{
        NSLog(@"blockG");
        int b = a + 1;
    };
    
    self.blockS = ^{
        NSLog(@"blockS");
        int b = a + 2;
    };
    
    
    
    [self testAddress];
    
    
    
    
    
}

- (void)testAddress{
    
    NSString *str = [NSString stringWithFormat:@"hello"];
    NSString *str_copy = [str copy];
    
    NSLog(@"str: %p  &%p str_copy:%p &%p",str,&str,str_copy ,&str_copy);
    
    self.string = str;
    NSLog(@"string:%p  &%p",self.string , &_string);
    
    
    int n1 = 5 , n2 = 7;
    NSLog(@"%p , %p",n1 , n2);
    [self sum:n1 b:n2];
    
    
}


- (void)sum:(int)a b:(int)b{
    
    NSLog(@"%p , %p",a,b);
}


- (void)PropertyTest{
    
    PropertyAClass *p = [[PropertyAClass alloc] init];
    [p obj_strongAssgiTest];

}

- (void)CopyTest{
    
    
    CopyModel *m = [CopyModel new];
    [m string_copy];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    __block int a = 0;
    void (^blockM)(void) = ^{
        
        NSLog(@"aaa");
        int b = a + 2;
    };
    
    
    //[self testAddress];
    
    
    self.blockG = blockM;
    self.blockS = blockM;
    
    blockM();
    
    
    
}

@end
