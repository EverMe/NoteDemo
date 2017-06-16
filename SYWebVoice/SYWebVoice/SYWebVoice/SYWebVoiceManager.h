//
//  SYWebVoiceManager.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYWebVoiceOperation.h"
#import "SYWebVoiceDownloader.h"
#import "SYWebVoiceCache.h"
#import "SYWebVoicePlayer.h"


typedef NS_OPTIONS(NSUInteger, SYWebVoiceOptions) {
    SYWebVoiceOptionsNone =  0,
    SYWebVoiceRetryFailed = 1 << 0,
};

typedef void(^SYWebVoiceCompletionBlock)(NSString *voicePath, NSError *error, NSURL *voiceURL);

typedef void(^SYWebVoiceCompletionWithFinishedBlock)(NSString *voicePath, NSError *error, BOOL finished, NSURL *voiceURL);

typedef NSString *(^SYWebVoiceCacheKeyFilterBlock)(NSURL *url);


@class SYWebVoiceManager;

@protocol SYWebVoiceManagerDelegate <NSObject>
@optional
/**
 * Controls which voice should be downloaded when the vioce is not found in the cache.
 *
 * @param voiceManager The current `SYWebVoiceManager`
 * @param voiceURL     The url of the voice to be downloaded
 *
 * @return Return NO to prevent the downloading of the voice on cache misses. If not implemented, YES is implied.
 */
- (BOOL)voiceManager:(SYWebVoiceManager *)voiceManager shouldDownloadVoiceForURL:(NSURL *)voiceURL;
@end

@interface SYWebVoiceManager : NSObject

@property (weak, nonatomic) id <SYWebVoiceManagerDelegate> delegate;
@property (strong, nonatomic, readonly) SYWebVoiceCache *voiceCache;
@property (strong, nonatomic, readonly) SYWebVoiceDownloader *voiceDownloader;
@property (strong, nonatomic, readonly) SYWebVoicePlayer *voicePlayer;

/**
 * The cache filter is a block used each time SYWebVoiceManager need to convert an URL into a cache key. This can
 * be used to remove dynamic part of an image URL.
 *
 * The following example sets a filter in the application delegate that will remove any query-string from the
 * URL before to use it as a cache key:
 *
 * @code
 
 [[SYWebVoiceManager sharedManager] setCacheKeyFilter:^(NSURL *url) {
 url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
 return [url absoluteString];
 }];
 
 * @endcode
 */
@property (nonatomic, copy) SYWebVoiceCacheKeyFilterBlock cacheKeyFilter;

/**
 * Returns global SDWebImageManager instance.
 *
 * @return SDWebImageManager shared instance
 */
+ (SYWebVoiceManager *)sharedManager;

/**
 * Allows to specify instance of cache and image downloader used with image manager.
 * @return new instance of `SDWebImageManager` with specified cache and downloader.
 */
- (instancetype)initWithCache:(SYWebVoiceCache *)cache downloader:(SYWebVoiceDownloader *)downloader player:(SYWebVoicePlayer*)palyer;


/**
 * Downloads the Voice at the given URL if not present in cache or return the cached version otherwise.
 *
 * @param url            The URL to the voice
 * @param options        A mask to specify options to use for this request
 * @param progressBlock  A block called while vocie is downloading
 * @param completedBlock A block called when operation has been completed.

 * @return Returns an NSObject conforming to SYWebVoiceOperation. Should be an instance of SYWebVoiceDownloaderOperation
 */
- (id <SYWebVoiceOperation>)downloadVoiceWithURL:(NSURL *)url
                                         options:(SYWebVoiceOptions)options
                                        progress:(SYWebVoiceDownloaderProgressBlock)progressBlock
                                       completed:(SYWebVoiceCompletionWithFinishedBlock)completedBlock;

/**
 * Cancel all current operations
 */
- (void)cancelAll;

/**
 * Check one or more operations running
 */
- (BOOL)isRunning;

/**
 *  Check if image has already been cached on disk only
 *
 *  @param url image url
 *
 *  @return if the image was already cached (disk only)
 */
- (BOOL)diskVoiceExistsForURL:(NSURL *)url;

/**
 *  Async check if image has already been cached on disk only
 *
 *  @param url              image url
 *  @param completionBlock  the block to be executed when the check is finished
 *
 *  @note the completion block is always executed on the main queue
 */
- (void)diskVoiceExistsForURL:(NSURL *)url
                   completion:(SYWebVoiceCheckCacheCompletionBlock)completionBlock;

/**
 *Return the cache key for a given URL
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;


- (void)playVoiceWithPath:(NSString *)path;
- (void)setVoiceFirstResponder:(id<SYWebVoicePlayerDelegate>)voiceView;

@end
