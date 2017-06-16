//
//  SYVocieView.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/16.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "SYVocieView.h"
#import "UIView+WebVoiceCache.h"

@interface SYVocieView ()<SYWebVoicePlayerDelegate>

@end

@implementation SYVocieView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch:)];
    [self addGestureRecognizer:tap];
    
}

- (void)tapTouch:(UITapGestureRecognizer *)tap{
    [self sy_playVoiceWithURL:[NSURL URLWithString:self.voiceURL] completed:^(NSString *voicePath, NSError *error, NSURL *voiceURL) {
        
        NSLog(@"completed");
        
    }];
}


- (void)voicePlayerwillStartPlaying:(SYWebVoicePlayer *)player{
    
    self.backgroundColor = [UIColor redColor];
    
}
- (void)voicePlayerDidFinishPlaying:(SYWebVoicePlayer *)player{
    
    self.backgroundColor = [UIColor cyanColor];
}


@end
