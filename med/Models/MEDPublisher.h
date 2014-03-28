//
//  MEDPublisher.h
//  med
//
//  Created by naoty on 2014/03/24.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MEDPublisherDelegate;

@interface MEDPublisher : NSObject

@property (nonatomic, weak) id <MEDPublisherDelegate> delegate;

- (id)initWithName:(NSString *)name;
- (void)runWithFilename:(NSString *)filename standardInput:(NSString *)standardInput;

@end

@protocol MEDPublisherDelegate <NSObject>

- (void)publisher:(MEDPublisher *)publisher didReceiveStandardOutput:(NSString *)standardOutput time:(NSTimeInterval)time;
- (void)publisher:(MEDPublisher *)publisher didReceiveStandardError:(NSString *)standardError time:(NSTimeInterval)time;

@end
