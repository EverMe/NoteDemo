//
//  SYWebVoiceCache.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SYWebVoiceQueryCompletedBlock)(NSString *voicePath);
typedef void(^SYWebVoiceCheckCacheCompletionBlock)(BOOL isInCache);

@interface SYWebVoiceCache : NSObject

/**
 *  disable iCloud backup [defaults to YES]
 */
@property (assign, nonatomic) BOOL shouldDisableiCloud;

/**
 * The maximum length of time to keep an voice in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;


/**
 * Returns global shared cache instance
 *
 * @return SDImageCache global instance
 */
+ (SYWebVoiceCache *)sharedVoiceCache;


- (NSString *)storeVoiceDataToDisk:(NSData *)voiceData forKey:(NSString *)key;

/**
 *  Check if Voice exists in disk cache already
 *
 *  @param key the key describing the url
 *
 *  @return YES if voice exists for the given key
 */
- (BOOL)diskVoiceExistsWithKey:(NSString *)key;

/**
 *  Async check if Voice exists in disk cache already
 *
 *  @param key             the key describing the url
 *  @param completionBlock the block to be executed when the check is done.
 *  @note the completion block will be always executed on the main queue
 */
- (void)diskImageExistsWithKey:(NSString *)key completion:(SYWebVoiceCheckCacheCompletionBlock)completionBlock;



/**
 * Query the disk cache asynchronously.
 *
 * @param key The unique key used to store the wanted voice
 */
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(SYWebVoiceQueryCompletedBlock)doneBlock;

@end
