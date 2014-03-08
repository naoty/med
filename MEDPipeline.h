//
//  MEDPipeline.h
//  med
//
//  Created by naoty on 2014/03/07.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MEDPipelineDelegate;

@interface MEDPipeline : NSObject

@property (nonatomic, weak) id <MEDPipelineDelegate> delegate;

- (void)addScript:(NSString *)script;
- (void)runWithInput:(NSString *)input;

@end

@protocol MEDPipelineDelegate <NSObject>

- (void)pipeline:(MEDPipeline *)pipeline didReceiveStandardOutput:(NSString *)standardOutput;

@end
