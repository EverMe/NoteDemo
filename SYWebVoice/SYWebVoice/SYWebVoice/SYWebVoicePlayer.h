//
//  SYWebVoicePlayer.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/16.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SYWebVoicePlayer;
@protocol SYWebVoicePlayerDelegate <NSObject>
@optional
- (void)becomePlayerFirstResponder; //点击播放view 该View即成为第一响应者
- (void)resignPlayerFirstResponder; //点击其他播放view或者当前view播放finish 会resign

- (void)voicePlayerwillStartPlaying:(SYWebVoicePlayer *)player; //即将开始播放
- (void)voicePlayerwillPausePlaying:(SYWebVoicePlayer *)player; //即将暂停播放
- (void)voicePlayerDidFinishPlaying:(SYWebVoicePlayer *)player; //已经完成播放

@end


@interface SYWebVoicePlayer : NSObject

@property (nonatomic, readonly, strong) AVAudioPlayer * audioPlayer;

@property (nonatomic, readonly ,copy) NSString *playingPath;

@property (nonatomic, getter=isPlaying,assign) BOOL playing;

@property (nonatomic, weak) id<SYWebVoicePlayerDelegate> delegate;

+(SYWebVoicePlayer *)sharedVoicePlayer;
- (void)playVoiceWithPath:(NSString *)path;
- (void)stop;


@end
