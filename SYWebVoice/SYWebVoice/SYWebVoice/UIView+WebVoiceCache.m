//
//  UIView+WebVoiceCache.m
//  SYWebVoice
//
//  Created by baoyewei on 2017/5/15.
//  Copyright © 2017年 baoyewei. All rights reserved.
//

#import "UIView+WebVoiceCache.h"
#import "objc/runtime.h"

static char voiceURLKey;
//static char TAG_ACTIVITY_INDICATOR;
//static char TAG_ACTIVITY_STYLE;
//static char TAG_ACTIVITY_SHOW;

#define voiceLoadOperationKey @"SYWebVoiceViewLoadKey"

@implementation UIView (WebVoiceCache)

- (void)sy_playVoiceWithURL:(NSURL *)url completed:(SYWebVoiceCompletionBlock)completedBlock{
    [self sy_playVoiceWithURL:url options:0 progress:nil completed:completedBlock];
}
- (void)sy_playVoiceWithURL:(NSURL *)url options:(SYWebVoiceOptions)options completed:(SYWebVoiceCompletionBlock)completedBlock{
    [self sy_playVoiceWithURL:url options:options progress:nil completed:completedBlock];
}
- (void)sy_playVoiceWithURL:(NSURL *)url options:(SYWebVoiceOptions)options progress:(SYWebVoiceDownloaderProgressBlock)progressBlock completed:(SYWebVoiceCompletionBlock)completedBlock{

    [self sy_cancelCurrentVoiceLoad];
    objc_setAssociatedObject(self, &voiceURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    if (!(options & SDWebImageDelayPlaceholder)) {
//        dispatch_main_async_safe(^{
//            self.image = placeholder;
//        });
//    }
//
    
    
    
    
    
    if (url) {
        
        [[SYWebVoiceManager sharedManager] setVoiceFirstResponder:self];
        __weak __typeof(self)wself = self;
        id <SYWebVoiceOperation> operation = [SYWebVoiceManager.sharedManager downloadVoiceWithURL:url options:options progress:progressBlock completed:^(NSString *voicePath, NSError *error, BOOL finished, NSURL *voiceURL) {
            
            if (!wself) return;
//            dispatch_main_sync_safe(^{
                if (!wself) return;
            
                if (voicePath &&  completedBlock)
                {
                    
                    [[SYWebVoiceManager sharedManager] playVoiceWithPath:voicePath];
                    completedBlock(voicePath, error, url);
                    return;
                }
                
                if (completedBlock && finished) {
                    
                    [[SYWebVoiceManager sharedManager] playVoiceWithPath:voicePath];
                    completedBlock(voicePath, error, voiceURL);
                }
//            });
        }];
        [self sy_setVoiceLoadOperation:operation forKey:voiceLoadOperationKey];
    } else {
        dispatch_main_async_safe(^{

            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:SYWebVoiceErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, url);
            }
        });
    }

}

/*** Cancel the current download */
- (void)sy_cancelCurrentVoiceLoad{
    [self sy_cancelVoiceLoadOperationWithKey:voiceLoadOperationKey];
}

@end


static char loadOperationKey;
@implementation UIView (WebVoiceCacheOperation)

- (NSMutableDictionary *)operationDictionary {
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

- (void)sy_setVoiceLoadOperation:(id)operation forKey:(NSString *)key {
    [self sy_cancelVoiceLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary setObject:operation forKey:key];
}

- (void)sy_cancelVoiceLoadOperationWithKey:(NSString *)key {
    // Cancel in progress downloader from queue
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    id operations = [operationDictionary objectForKey:key];
    if (operations) {
        if ([operations isKindOfClass:[NSArray class]]) {
            for (id <SYWebVoiceOperation> operation in operations) {
                if (operation) {
                    [operation cancel];
                }
            }
        } else if ([operations conformsToProtocol:@protocol(SYWebVoiceOperation)]){
            [(id<SYWebVoiceOperation>) operations cancel];
        }
        [operationDictionary removeObjectForKey:key];
    }
}

- (void)sy_removeVoiceLoadOperationWithKey:(NSString *)key {
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary removeObjectForKey:key];
}


@end
