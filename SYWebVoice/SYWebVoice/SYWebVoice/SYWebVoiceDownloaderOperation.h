//
//  SYWebVoiceDownloaderOperation.h
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYWebVoiceOperation.h"
#import "SYWebVoiceDownloader.h"

@interface SYWebVoiceDownloaderOperation : NSOperation <SYWebVoiceOperation, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/**
 * The request used by the operation's task.
 */
@property (strong, nonatomic, readonly) NSURLRequest *request;

/**
 * The operation's task
 */
@property (strong, nonatomic, readonly) NSURLSessionTask *dataTask;

/**
 * The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 *
 * This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * The response returned by the operation's connection.
 */
@property (strong, nonatomic) NSURLResponse *response;
- (id)initWithRequest:(NSURLRequest *)request
            inSession:(NSURLSession *)session
             progress:(SYWebVoiceDownloaderProgressBlock)progressBlock
            completed:(SYWebVoiceDownloaderCompletedBlock)completedBlock
            cancelled:(SYWebVoiceNoParamsBlock)cancelBlock;

@end
