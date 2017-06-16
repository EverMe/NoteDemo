//
//  SYWebVoiceDownloader.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYWebVoiceOperation.h"
#import "SYWebVoiceCompat.h"


extern NSString *const SYWebVoiceDownloadStartNotification;
extern NSString *const SYWebVoiceDownloadStopNotification;

typedef void(^SYWebVoiceDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^SYWebVoiceDownloaderCompletedBlock)(NSString *voicePath, NSError *error, BOOL finished);

typedef NSDictionary *(^SYWebVoiceDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);



@interface SYWebVoiceDownloader : NSObject

@property (assign, nonatomic) NSInteger maxConcurrentDownloads;

/**
 * Shows the current amount of downloads that still need to be downloaded
 */
@property (readonly, nonatomic) NSUInteger currentDownloadCount;

/**
 *  The timeout value (in seconds) for the download operation. Default: 15.0.
 */
@property (assign, nonatomic) NSTimeInterval downloadTimeout;

/**
 * Set filter to pick headers for downloading image HTTP request.
 *
 * This block will be invoked for each downloading image request, returned
 * NSDictionary will be used as headers in corresponding HTTP request.
 */
@property (nonatomic, copy) SYWebVoiceDownloaderHeadersFilterBlock headersFilter;

/**
 *  Set the default URL credential to be set for request operations.
 */
@property (strong, nonatomic) NSURLCredential *urlCredential;


/**
 *  Singleton method, returns the shared instance
 *
 *  @return global shared instance of downloader class
 */
+ (SYWebVoiceDownloader *)sharedDownloader;


- (id <SYWebVoiceOperation>)downloadImageWithURL:(NSURL *)url
                                        progress:(SYWebVoiceDownloaderProgressBlock)progressBlock
                                       completed:(SYWebVoiceDownloaderCompletedBlock)completedBlock;

@end
