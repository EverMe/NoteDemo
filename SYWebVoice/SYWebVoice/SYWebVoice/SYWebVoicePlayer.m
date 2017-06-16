//
//  SYWebVoicePlayer.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/16.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "SYWebVoicePlayer.h"

@interface SYWebVoicePlayer () <AVAudioPlayerDelegate>

@property (nonatomic, readwrite ,strong) AVAudioPlayer * audioPlayer;

@property (nonatomic, readwrite ,copy) NSString *playingPath;

@end

@implementation SYWebVoicePlayer


+ (SYWebVoicePlayer *)sharedVoicePlayer{
    
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setDelegate:(id<SYWebVoicePlayerDelegate>)delegate{
    
    if (_delegate != delegate) {
        
        if ([_delegate respondsToSelector:@selector(resignPlayerFirstResponder)]) {
            [_delegate resignPlayerFirstResponder];
        }
        
        _delegate = delegate;
        
        if ([_delegate respondsToSelector:@selector(becomePlayerFirstResponder)]) {
            [_delegate becomePlayerFirstResponder];
        }
    }
}

- (void)playVoiceWithPath:(NSString *)path{
    
    if (!path) {
        return;
    }
    
    if (![path isEqualToString:self.playingPath]) {
        
        [self stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        self.playingPath = path;
        [self play];
    }else{
        
        if (!self.playing) {
            [self play];
        }else{
            [self pause];
        }
    }
}

- (void)stop{
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = 0;
}
- (void)play{
    [self.audioPlayer play];
    if ([_delegate respondsToSelector:@selector(voicePlayerwillStartPlaying:)]) {
        [_delegate voicePlayerwillStartPlaying:self];
    }
}
- (void)pause{
    [self.audioPlayer pause];
    if ([_delegate respondsToSelector:@selector(voicePlayerwillPausePlaying:)]) {
        [_delegate voicePlayerwillPausePlaying:self];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([_delegate respondsToSelector:@selector(voicePlayerDidFinishPlaying:)]) {
        [_delegate voicePlayerDidFinishPlaying:self];
    }
    if ([_delegate respondsToSelector:@selector(resignPlayerFirstResponder)]) {
        [_delegate resignPlayerFirstResponder];
    }
}
- (BOOL)isPlaying{
    return self.audioPlayer.playing;
}


@end
