//
//  UIViewMethodVC.m
//  TestAnimation
//
//  Created by baoyewei on 17/3/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "UIViewMethodVC.h"

@interface UIViewMethodVC ()

#define kSceneH 200
#define kSceneW self.view.frame.size.width
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (assign, nonatomic) BOOL sceneNum;
@end

@implementation UIViewMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sceneNum = 0;
 
    
    
    [self test1];
    
}

- (void)test1{
    
    
    UIView *aView = [self addNewScene];
   

}

- (UIView *)addNewScene{
    
    UIView *aView = [[UIView alloc] init];
    aView.frame = CGRectMake(0, self.sceneNum*kSceneH, kSceneW, kSceneH);
    aView.backgroundColor = kRandomColor;
    [self.mScrollView addSubview:aView];
    self.sceneNum++;
    self.mScrollView.contentSize = CGSizeMake(kSceneW, self.sceneNum*kSceneH);
    return aView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
