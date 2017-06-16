//
//  SYWebVoiceManager.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "SYWebVoiceManager.h"
#import "SYWebVoiceCompat.h"

@interface SDWebVoiceCombinedOperation : NSObject <SYWebVoiceOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) SYWebVoiceNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *cacheOperation;
@end

@implementation SDWebVoiceCombinedOperation

- (void)setCancelBlock:(SYWebVoiceNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
        
        // TODO: this is a temporary fix to #809.
        // Until we can figure the exact cause of the crash, going with the ivar instead of the setter
        //        self.cancelBlock = nil;
        _cancelBlock = nil;
    }
}

@end


@interface SYWebVoiceManager ()

@property (strong, nonatomic, readwrite) SYWebVoiceCache *voiceCache;
@property (strong, nonatomic, readwrite) SYWebVoiceDownloader *voiceDownloader;
@property (strong, nonatomic, readwrite ) SYWebVoicePlayer *voicePlayer;
@property (strong, nonatomic) NSMutableSet *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

@property (nonatomic, weak) id voiceViewModel; //记录正在播放动画的model

@end


@implementation SYWebVoiceManager

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    SYWebVoiceCache *cache = [SYWebVoiceCache sharedVoiceCache];
    SYWebVoiceDownloader *downloader = [SYWebVoiceDownloader sharedDownloader];
    SYWebVoicePlayer *voicePlayer = [SYWebVoicePlayer sharedVoicePlayer];
    return [self initWithCache:cache downloader:downloader player:voicePlayer];
}

- (instancetype)initWithCache:(SYWebVoiceCache *)cache downloader:(SYWebVoiceDownloader *)downloader player:(SYWebVoicePlayer*)palyer{
    if ((self = [super init])) {
        _voiceCache = cache;
        _voiceDownloader = downloader;
        _voicePlayer = palyer;
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (!url) {
        return @"";
    }
    
    if (self.cacheKeyFilter) {
        return self.cacheKeyFilter(url);
    } else {
        return [url absoluteString];
    }
}

- (BOOL)diskVoiceExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return [self.voiceCache diskVoiceExistsWithKey:key];
}

- (void)diskVoiceExistsForURL:(NSURL *)url
                   completion:(SYWebVoiceCheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    [self.voiceCache diskImageExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // the completion block of checkDiskCacheForImageWithKey:completion: is always called on the main queue, no need to further dispatch
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}

- (id <SYWebVoiceOperation>)downloadVoiceWithURL:(NSURL *)url
                                         options:(SYWebVoiceOptions)options
                                        progress:(SYWebVoiceDownloaderProgressBlock)progressBlock
                                       completed:(SYWebVoiceCompletionWithFinishedBlock)completedBlock{
    
    // Invoking this method without a completedBlock is pointless
//    NSAssert(completedBlock != nil, @"If you mean to prefetch the image, use -[SDWebImagePrefetcher prefetchURLs] instead");
    
    // Very common mistake is to send the URL using NSString object instead of NSURL. For some strange reason, XCode won't
    // throw any warning for this type mismatch. Here we failsafe this error by allowing URLs to be passed as NSString.
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    // Prevents app crashing on argument type error like sending NSNull instead of NSURL
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    
    __block SDWebVoiceCombinedOperation *operation = [SDWebVoiceCombinedOperation new];
    __weak SDWebVoiceCombinedOperation *weakOperation = operation;
    
    BOOL isFailedUrl = NO;
    @synchronized (self.failedURLs) {
        isFailedUrl = [self.failedURLs containsObject:url];
    }
    
    if (url.absoluteString.length == 0 || (!(options & SYWebVoiceRetryFailed) && isFailedUrl)) {
        dispatch_main_sync_safe(^{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            completedBlock(nil, error, YES, url);
        });
        return operation;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    NSString *key = [self cacheKeyForURL:url];
    
    operation.cacheOperation = [self.voiceCache queryDiskCacheForKey:key done:^(NSString *voicePath) {
        if (operation.isCancelled) {
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
            return;
        }
        
        if ((!voicePath || options ) && (![self.delegate respondsToSelector:@selector(voiceManager:shouldDownloadVoiceForURL:)])) {
            if (voicePath && options) {
                dispatch_main_sync_safe(^{
                    // If image was found in the cache but SDWebImageRefreshCached is provided, notify about the cached image
                    // AND try to re-download it in order to let a chance to NSURLCache to refresh it from server.
                    completedBlock(voicePath, nil, YES, url);
                });
            }
            
            id <SYWebVoiceOperation> subOperation = [self.voiceDownloader downloadImageWithURL:url progress:progressBlock completed:^(NSString *voicePath, NSError *error, BOOL finished) {
                __strong __typeof(weakOperation) strongOperation = weakOperation;
                if (!strongOperation || strongOperation.isCancelled) {
                    // Do nothing if the operation was cancelled
                    // See #699 for more details
                    // if we would call the completedBlock, there could be a race condition between this block and another completedBlock for the same object, so if this one is called second, we will overwrite the new data
                }
                else if (error) {
                    dispatch_main_sync_safe(^{
                        if (strongOperation && !strongOperation.isCancelled) {
                            completedBlock(nil, error, finished, url);
                        }
                    });
                    
                    if (   error.code != NSURLErrorNotConnectedToInternet
                        && error.code != NSURLErrorCancelled
                        && error.code != NSURLErrorTimedOut
                        && error.code != NSURLErrorInternationalRoamingOff
                        && error.code != NSURLErrorDataNotAllowed
                        && error.code != NSURLErrorCannotFindHost
                        && error.code != NSURLErrorCannotConnectToHost) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs addObject:url];
                        }
                    }
                }
                else {
                    if ((options & SYWebVoiceRetryFailed)) {
                        @synchronized (self.failedURLs) {
                            [self.failedURLs removeObject:url];
                        }
                    }
                    dispatch_main_sync_safe(^{
                        if (strongOperation && !strongOperation.isCancelled) {
                            completedBlock(voicePath, nil, finished, url);
                        }
                    });
                }
                
                if (finished) {
                    @synchronized (self.runningOperations) {
                        if (strongOperation) {
                            [self.runningOperations removeObject:strongOperation];
                        }
                    }
                }
            }];
            operation.cancelBlock = ^{
                [subOperation cancel];
                
                @synchronized (self.runningOperations) {
                    __strong __typeof(weakOperation) strongOperation = weakOperation;
                    if (strongOperation) {
                        [self.runningOperations removeObject:strongOperation];
                    }
                }
            };
        }
        else if (voicePath) {
            dispatch_main_sync_safe(^{
                __strong __typeof(weakOperation) strongOperation = weakOperation;
                if (strongOperation && !strongOperation.isCancelled) {
                    completedBlock(voicePath, nil, YES, url);
                }
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
        }
        else {
            // Image not in cache and download disallowed by delegate
            dispatch_main_sync_safe(^{
                __strong __typeof(weakOperation) strongOperation = weakOperation;
                if (strongOperation && !weakOperation.isCancelled) {
                    completedBlock(nil, nil, YES, url);
                }
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
        }
    }];
    
    return operation;
}
- (void)playVoiceWithPath:(NSString *)path OnView:(id<SYWebVoicePlayerDelegate>)voiceView{
    
    
}

- (void)cancelAll {
    @synchronized (self.runningOperations) {
        NSArray *copiedOperations = [self.runningOperations copy];
        [copiedOperations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeObjectsInArray:copiedOperations];
    }
}

- (BOOL)isRunning {
    BOOL isRunning = NO;
    @synchronized(self.runningOperations) {
        isRunning = (self.runningOperations.count > 0);
    }
    return isRunning;
}


- (void)playVoiceWithPath:(NSString *)path{
    [self.voicePlayer playVoiceWithPath:path];
}
- (void)setVoiceFirstResponder:(id<SYWebVoicePlayerDelegate>)voiceView{
    self.voicePlayer.delegate = voiceView;
}

@end
