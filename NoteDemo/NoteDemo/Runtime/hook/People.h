//
//  People.h
//  NoteDemo
//
//  Created by baoyewei on 2019/4/16.
//  Copyright © 2019 byw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PeopleDelegate <NSObject>

- (void)peopleRun;

@end



@interface People : NSObject

@property (nonatomic, weak) id<PeopleDelegate> delegate;

- (void)eat;

- (void)see;
@end

NS_ASSUME_NONNULL_END
