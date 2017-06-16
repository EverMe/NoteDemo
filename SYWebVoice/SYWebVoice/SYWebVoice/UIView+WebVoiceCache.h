//
//  UIView+WebVoiceCache.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYWebVoiceManager.h"

@interface UIView (WebVoiceCache)

- (void)sy_playVoiceWithURL:(NSURL *)url completed:(SYWebVoiceCompletionBlock)completedBlock;
- (void)sy_playVoiceWithURL:(NSURL *)url options:(SYWebVoiceOptions)options completed:(SYWebVoiceCompletionBlock)completedBlock;
- (void)sy_playVoiceWithURL:(NSURL *)url options:(SYWebVoiceOptions)options progress:(SYWebVoiceDownloaderProgressBlock)progressBlock completed:(SYWebVoiceCompletionBlock)completedBlock;

/*** Cancel the current download */
- (void)sy_cancelCurrentVoiceLoad;
@end


@interface UIView (WebVoiceCacheOperation)

/**
 *  Set the image load operation (storage in a UIView based dictionary)
 *
 *  @param operation the operation
 *  @param key       key for storing the operation
 */
- (void)sy_setVoiceLoadOperation:(id)operation forKey:(NSString *)key;

/**
 *  Cancel all operations for the current UIView and key
 *
 *  @param key key for identifying the operations
 */
- (void)sy_cancelVoiceLoadOperationWithKey:(NSString *)key;

/**
 *  Just remove the operations corresponding to the current UIView and key without cancelling them
 *
 *  @param key key for identifying the operations
 */
- (void)sy_removeVoiceLoadOperationWithKey:(NSString *)key;

@end
