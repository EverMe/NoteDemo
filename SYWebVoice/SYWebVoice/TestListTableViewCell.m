//
//  TestListTableViewCell.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/6/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "TestListTableViewCell.h"
#import "UIView+WebVoiceCache.h"

@interface TestListTableViewCell () <SYWebVoicePlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


@property (nonatomic, copy) NSString *voiceURL;
@property (nonatomic, assign) BOOL playing;
@end

@implementation TestListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSMutableArray *animaImgs = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        NSString *name = [NSString stringWithFormat:@"voice_%02d",i];
        [animaImgs addObject:[UIImage imageNamed:name]];
    }
    self.animationImgView.animationImages = animaImgs;
    self.animationImgView.animationDuration = 0.5f;
    
}

- (void)setCellData:(NSString *)vocieURL playing:(BOOL)playing{
    
    
    self.voiceURL = vocieURL;
    self.playing = playing;
    
    if (playing) {
        [self startAnimation];
    }else{
        [self stopAnimation];
    }
}

- (IBAction)playBtnClick:(id)sender {
    
    if (self.playVoiceBlock) {
        self.playVoiceBlock(self, self.voiceURL);
    }
    
//    [self sy_playVoiceWithURL:[NSURL URLWithString:self.voiceURL] completed:^(NSString *voicePath, NSError *error, NSURL *voiceURL) {
//        
//        NSLog(@"completed");
//        
//    }];
    
}

- (void)startAnimation{
     [self.animationImgView startAnimating];
    self.playing = YES;
}

- (void)stopAnimation{
    [self.animationImgView stopAnimating];
    self.playing = NO;
    self.animationImgView.image = [UIImage imageNamed:@"voice_02"];
}
- (void)becomePlayerFirstResponder{
//     [self startAnimation];
}
- (void)resignPlayerFirstResponder{
    [self stopAnimation];
}
- (void)voicePlayerwillStartPlaying:(SYWebVoicePlayer *)player{
    [self startAnimation];
}
- (void)voicePlayerDidFinishPlaying:(SYWebVoicePlayer *)player{
    [self stopAnimation];
    if (self.playFinishBlock) {
        self.playFinishBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
