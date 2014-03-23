//
//  MEDPublisher.m
//  med
//
//  Created by naoty on 2014/03/24.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

#import "MEDPublisher.h"
#import "MEDConfig.h"

@interface MEDPublisher ()
@property (nonatomic, copy) NSString *name;
@end

@implementation MEDPublisher

- (id)initWithName:(NSString *)name
{
    self = [self init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)runWithFilename:(NSString *)filename standardInput:(NSString *)standardInput
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        NSTask *task = [NSTask new];
        task.launchPath = @"/bin/sh";
        task.arguments = @[@"-l", @"-c", self.name];
        task.environment = @{@"PATH": [[MEDConfig sharedConfig] path]};
        
        NSPipe *inputPipe = [NSPipe pipe];
        [[inputPipe fileHandleForWriting] writeData:[standardInput dataUsingEncoding:NSUTF8StringEncoding]];
        task.standardInput = inputPipe;
        
        [task launch];
    });
}

@end
