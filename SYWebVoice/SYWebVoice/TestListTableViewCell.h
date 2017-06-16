//
//  TestListTableViewCell.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/6/14.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestListTableViewCell : UITableViewCell

- (void)setCellData:(NSString *)vocieURL playing:(BOOL)playing;

@property (nonatomic, copy) void (^playVoiceBlock)(TestListTableViewCell *cell,NSString *voiceURL);
@property (nonatomic, copy) void (^playFinishBlock)();

@end
