//
//  ViewController.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SYVocieView.h"
#import "TestListViewController.h"

@interface ViewController ()<AVAudioPlayerDelegate>

@end

@implementation ViewController
- (IBAction)listPush:(id)sender {
    
    TestListViewController *vc = [TestListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    
    SYVocieView *view1 = [[SYVocieView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    view1.backgroundColor = [UIColor cyanColor];
    view1.voiceURL = @"https://video-cdn.suiyueyule.com/20170509232614-Fq0DLkGkOXltQDsmOrQCLWQnc06k.mp3?auth_key=1494930046-0-0-5f3f2c7f90cb06725a80e6c966394064";
    [self.view addSubview:view1];
    
    SYVocieView *view2 = [[SYVocieView alloc] initWithFrame:CGRectMake(100, 300, 200, 100)];
    view2.backgroundColor = [UIColor cyanColor];
    view2.voiceURL = @"https://video-cdn.suiyueyule.com/20170515220925-FvIm1yXaHPrwEzK3ubLi4BJPyHGL.mp3?auth_key=1494930073-0-0-04f60d611b26948235da7521d53e5d98";
    [self.view addSubview:view2];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
